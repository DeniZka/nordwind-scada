class_name NordWind
extends Node

signal signalsUpdated

enum {RS_WAIT_HEADER, RS_READ_BODY, RS_PARSE_DATA}
enum {CMD_PAUSE=23, CMD_PLAY=25, CMD_KILL=15}
const HEADER_SIZE = 4
const OP_SIZE = 1

const DAT_INITIALIZE = 0
const DAT_ADDRDVARS = 1
const DAT_ADDWRVARS = 2
const DAT_EXCHANGE = 3
const DAT_RMRDVARS = 4
const DAT_RMWRVARS = 5
const DAT_CMD = 6
const DAT_SAVESTATE = 7
const DAT_LOADSTATE = 8
const DAT_EXEC = 9
const DAT_VARLIST = 10
const DAT_ARCHIVE_INFO = 11
const DAT_ARCHIVE_DATA = 12
const DAT_ARCHIVE_EVENTS = 13

#NordWind settings response
var step = 0.0
var connection_time = 0.0
var flags = 0


var srv: TCPServer = null
var cli: StreamPeerTCP = null
var rcv_state = RS_WAIT_HEADER
var packet_size = 0
var op = -1
var data: PackedByteArray = []

var rdsigs_new = [] #signals to be added
var rdsigs = []
var rdsigs_old = [] #signal to be remvoed

var wrsigs_new = []
var wrsigs = []
var wrsigs_old = []

var sigs_not_found = []

#achive infor
var ar_start_time = 0.0
var ar_end_time = 0.0
var ar_points = 0

var timeout = 1000

func srvConnect(ip: String, port = 22375, timeout = 1000):
	self.timeout = timeout
	cli = StreamPeerTCP.new()
	#cli.set_no_delay ( true ) #???? need????
	#seems no need to "no delay" to auto packet merging
	var res = cli.connect_to_host(ip, port)
	#wait connection
	var ms = Time.get_ticks_msec()
	while (cli.get_status() != cli.STATUS_CONNECTED):
		if Time.get_ticks_msec() - ms >= timeout:
			Log.log("Подключение к %s не удалось" % ip)
			return false
		cli.poll()
#	cli.big_endian = true
		
#	cli.set_no_delay ( true )
#	print(res)
	if res != OK:
		print("can't connect to server")
		cli = null
		return false
	else:
		print("connected to server")
		return true
		
func isStatusConnected():
	cli.poll()
	return (cli.get_status() == cli.STATUS_CONNECTED)

func cleanSyncLists():
		#clean up lists for resync after next conection
		if not rdsigs_old.is_empty():
			for rdo in rdsigs_old: #will not need to delete future just remove from list
				if rdo in rdsigs:
					rdsigs.erase(rdo)
			rdsigs_old.clear()
		#check not clean list prevously, save _new list
		if not rdsigs.is_empty():
			rdsigs_new = rdsigs.duplicate()
			rdsigs.clear()
		
		if not rdsigs_new.is_empty():	
			for s in rdsigs_new:
				s.clear()
		
		if not wrsigs_old.is_empty():
			for wro in wrsigs_old:
				if wro in wrsigs:
					wrsigs.erase(wro)
			wrsigs_old.clear()
			
		if not wrsigs.is_empty():
			wrsigs_new = wrsigs.duplicate()
			wrsigs.clear()
			
		if not wrsigs_new.is_empty():	
			for s in wrsigs_new:
				s.clear()

func srvDisconnect():
	if cli:
		cli.disconnect_from_host()
		cli = null
		cleanSyncLists()
		
func srvConnected():
	if cli:
		cli.poll()
		if cli.get_status() != cli.STATUS_CONNECTED:
			cli = null
			cleanSyncLists()
			return false
		else:
			return true
	else:
		cleanSyncLists()
		return false
		
func _sendStdStrCmd(s, op):
	if not srvConnected():
		return null
	
	const LEN_SIZE = 4
	var size = 0
	var data = PackedByteArray()
	var offset = 0
	
	const ID_SIZE = 4
	
	#no string size
	var pre_size = HEADER_SIZE + OP_SIZE + ID_SIZE + LEN_SIZE
	data.resize(pre_size)

	offset += HEADER_SIZE;
	data.encode_u8(offset, op)
	offset += OP_SIZE
	data.encode_u32(offset, 0)
	offset += ID_SIZE
	data.encode_u32(offset, s.length())
	offset += LEN_SIZE
	#attach string buffer size
	data += s.to_ascii_buffer()
	#real size
	data.encode_u32(0, data.size() - HEADER_SIZE)
	#send
	cli.put_data(data)
	print(data)
	
#	while cli.get_available_bytes() <= 0:
	cli.poll()
	print("available: ", cli.get_available_bytes(), " bytes")

	
	var res_l = cli.get_u32()
	print("result_len: ", res_l)
	return cli.get_data(res_l)[1]
	
func sendExec(s: String):
	var res: PackedByteArray = _sendStdStrCmd(s, DAT_EXEC)
	print("result")
	if res.size() != 5:
		print("response len error")
	#result and CRC
	return [res.decode_u8(0), res.decode_u32(1)]
	
#algo = <algo-name>#<config-name> Example: algo1#default.conf
func sendInitialization(algo: String):
	if not srvConnected():
		return null
	
	const LEN_SIZE = 4
	var size = 0
	var data = PackedByteArray()
	var offset = 0
	
	const ID_SIZE = 4
	
	#no string size
	var pre_size = HEADER_SIZE + OP_SIZE + ID_SIZE + LEN_SIZE
	data.resize(pre_size)

	offset += HEADER_SIZE;
	data.encode_u8(offset, DAT_INITIALIZE)
	offset += OP_SIZE
	data.encode_u32(offset, -1)
	offset += ID_SIZE
	data.encode_u32(offset, algo.length())
	offset += LEN_SIZE
	#attach string buffer size
	data += algo.to_ascii_buffer()
	#real size
	data.encode_u32(0, data.size() - HEADER_SIZE)
	#send
	cli.put_data(data)
	data.clear()
	print(data)
	
	print("available: ", cli.get_available_bytes(), " bytes")

	var res_l = cli.get_u32()
	if res_l != 5:
		print("Nordwind connection Initialization Error")
		return [-1, -1]
	var res: PackedByteArray = cli.get_data(res_l)[1]
	print("Initia", res)
	#error and CRC
	
	return [res.decode_u8(0), res.decode_u32(1)]
	
func findRdSignal(sname):
	for s in rdsigs:
		if s.name == sname:
			return s
	return null
			
func findWrSignal(sname):
	for s in wrsigs:
		if s.name == sname:
			return s
	return null

#variable list could be created once
func addVar(sig: nwSignal):
	if sig.direction == sig.DIR_READ:
		if sig in rdsigs: #check already in list
			return false
		if sig in rdsigs_new:
			return false #already await for sync
		rdsigs_new.append(sig)
		return true
	
	if sig.direction == sig.DIR_WRITE:
		if sig in wrsigs:
			return false
		if sig in wrsigs_new:
			return false
		wrsigs_new.append(sig)
		return true

func rmVar(sig: nwSignal):
	#FIXME: check by names
	#check isgnal is invalid
	if sig.VID == nwSignal.INVALID_SIGNAL:
		return false
		
	if sig.direction == sig.DIR_READ:
		if not sig in rdsigs: #check is not already synced
			return false
		if sig in rdsigs_old:
			return false #already await for remove sync
		rdsigs_old.append(sig)
		return true
	
	if sig.direction == sig.DIR_WRITE:
		if not sig in wrsigs:
			return false
		if sig in wrsigs_old:
			return false
		wrsigs_old.append(sig)
		return true
		
func _sendSyncAdd(new, main):
	if not self.srvConnected():
		return false
		
	var size = 0
	var data = PackedByteArray()
	var offset = 0
	const SIG_COUNT = 4
	const NAME_LEN = 4
	
	var op = DAT_ADDRDVARS
	#already checket length
	if new[0].direction == nwSignal.DIR_WRITE:
		op = DAT_ADDWRVARS
	
	data.resize(HEADER_SIZE + OP_SIZE + SIG_COUNT)
	offset += HEADER_SIZE
	data.encode_u8(offset, op)
	offset += OP_SIZE
	data.encode_u32(offset, new.size())
	offset += SIG_COUNT
	var l = 0
	for s in new:
		data.resize(data.size() + NAME_LEN)
		l = s.name.length()
		data.encode_u32(offset, l)
		offset += NAME_LEN
		data += s.name.to_ascii_buffer()
		offset += l
	
	#FINALLY SET HEADER LEN
	data.encode_u32(0, data.size() - HEADER_SIZE)
	cli.put_data(data)
	data.clear()
	
	#now receive response and parce it 
#	return #FIXME: TOBE REMOVED WHEN TESTED
	
	l = cli.get_u32()
	for s in new:
		s.type = cli.get_u8()
		#FIXME: may be loop with changin array siszes
		for i in range(3):
			s.dims[i] = cli.get_u32()
		s.resize()
		if l > 13: #
			s.VID = cli.get_u32()
		else:
			s.VID = -1
			print(s.name, " has no VID")
		
	#organize lists
	while not new.is_empty():
		#add only signal found
		if new[0].type != nwSignal.INVALID_SIGNAL:
			main.append(new[0])
		else:
			sigs_not_found.append(new[0])
		#remove anyway
		new.remove_at(0)
	
func _sendSyncRm(old, main):
	#FIXME: function is useless cause of no VID mostly
	var size = 0
	var data = PackedByteArray()
	var offset = 0
	const SIG_COUNT = 4
	const VID_SIZE = 4
	
	var op = DAT_RMRDVARS
	if old[0].direction == nwSignal.DIR_WRITE:
		op = DAT_RMWRVARS
	

	data.resize(HEADER_SIZE + OP_SIZE + SIG_COUNT + (old.size() * VID_SIZE))
	offset += HEADER_SIZE
	data.encode_u8(offset, op)
	offset += OP_SIZE
	data.encode_u32(offset, old.size())
	offset += SIG_COUNT
	for s in old:
		data.encode_u32(offset, s.VID)
		offset += VID_SIZE
	#FINALLY SET HEADER LEN
	data.encode_u32(0, data.size() - HEADER_SIZE)
	cli.put_data(data)
	data.clear()
	
	return
	#get response 
	var l = cli.get_u32()
	if l > 0:
		data = cli.get_data(l)
		print("WTF? ", data)
		
	#cleanup lists
	for s in old:
		main.erase(s)
	old.clear()
	
		
#need to resync after reconnection!!!
func sendSyncVarList():
	sigs_not_found.clear()
	#TODO: add read var list
	if not rdsigs_new.is_empty():
		_sendSyncAdd(rdsigs_new, rdsigs)
	#TODO: add write var list
	if not wrsigs_new.is_empty():
		_sendSyncAdd(wrsigs_new, wrsigs)
	#TOOD: rm read var list
	if not rdsigs_old.is_empty():
		_sendSyncRm(rdsigs_old, rdsigs)
	#TODO: rm write var list
	if not wrsigs_old.is_empty():
		_sendSyncRm(wrsigs_old, wrsigs)

#change execution status 
func sendCommand(cmd = CMD_PLAY):
	if not self.srvConnected():
		return false
		
	var data = PackedByteArray()
	var offset = 0
	const CMD_SIZE = 4
	
	data.resize(HEADER_SIZE + OP_SIZE + CMD_SIZE)
	offset += HEADER_SIZE
	data.encode_u8(offset, DAT_CMD)
	offset += OP_SIZE
	data.encode_u32(offset, cmd)
	#FINALLY SET HEADER LEN
	data.encode_u32(0, data.size() - HEADER_SIZE)
	cli.put_data(data)
	data.clear()
	
	return false #FIXME: remove
	
	cli.get_u32()
	if cli.get_u8():
		return false #some error
	else:
		return true #no error

#Send write writeable signals and read readable signals
func sendExchnge():
	if not self.srvConnected():
		return false
	#check lists are approved
	if rdsigs.is_empty():
		return false
	if wrsigs.is_empty():
		return false
	
	var data = PackedByteArray()
	var offset = 0
	
	#calculate wirte signal sizes
	var wrsize = 0
	for s in wrsigs:
		wrsize += s.vals.size()
	
	data.resize(HEADER_SIZE + OP_SIZE + wrsize)
	offset += HEADER_SIZE
	data.encode_u8(offset, DAT_EXCHANGE)
	offset += OP_SIZE
	for s in wrsigs:
		#push as type format
		match s.type:
			nwSignal.FLOAT64:
				for v in s.vals:
					data.encode_double(offset, v)
					offset += 8
			nwSignal.CHAR8:
				for v in s.vals:
					data.encode_u8(offset, v)
					offset += 1
			nwSignal.INT32:
				for v in s.vals:
					data.encode_s32(offset, v)
					offset += 4
			#TODO: finish all the signal types
	#FINALLY SET HEADER LEN
	data.encode_u32(0, data.size() - HEADER_SIZE)
	cli.put_data(data)
	data.clear()
	
	return #FIXME: remove
	
	cli.get_u32()
	step = cli.get_double()
	connection_time = cli.get_double()
	flags = cli.get_u32()
	for s in rdsigs:
		match s.type:
			nwSignal.FLOAT64:
				for i in range(s.vals.size()):
					s.vals[i] = cli.get_double()
			nwSignal.CHAR8:
				for i in range(s.vals.size()):
					s.vals[i] = cli.get_u8()
			nwSignal.INT32:
				for i in range(s.vals.size()):
					s.vals[i] = cli.get_32()
			#TODO: complete other signal types
			
	emit_signal("signalsUpdated")
	
func _findByName(sn: String, arr):
	for s in arr:
		if s.name == sn:
			return s
	return null
	
func signalsByDict(dev: String, sd, dir = nwSignal.DIR_READ):
	for k in sd:
		#get full signal string
		#        701   GTV   001    _   open
		var ss = dev + "_" + k
		if dir == nwSignal.DIR_READ:
			sd[k] = _findByName(ss, rdsigs)
			if sd[k]:
				continue
			sd[k] = _findByName(ss, rdsigs_new)
			if sd[k]:
				continue
		else:
			sd[k] = _findByName(ss, wrsigs)
			if sd[k]:
				continue
			sd[k] = _findByName(ss, wrsigs_new)
			if sd[k]:
				continue
		#no signal found
		var s = nwSignal.new(ss, dir)
		addVar(s)
		sd[k] = s
	
func sendSaveState(state_name):
	var res: PackedByteArray = _sendStdStrCmd(state_name, DAT_SAVESTATE)
	if res.size() != 1:
		print("response len error")
	#result 0-ok
	return res.decode_u8(0)
	
func sendLoadState(state_name):
	var res: PackedByteArray = _sendStdStrCmd(state_name, DAT_LOADSTATE)
	if res.size() != 1:
		print("response len error")
	#result 0-ok
	return res.decode_u8(0)
	
func sendGetAvailableVarList():
	if not self.srvConnected():
		return false
		
	var data = PackedByteArray()
	var offset = 0
	const CMD_SIZE = 4
	
	data.resize(HEADER_SIZE + OP_SIZE + CMD_SIZE)
	offset += HEADER_SIZE
	data.encode_u8(offset, DAT_VARLIST)
	offset += OP_SIZE
	data.encode_u32(offset, 1) #mask not Elon
	#FINALLY SET HEADER LEN
	data.encode_u32(0, data.size() - HEADER_SIZE)
	cli.put_data(data)
	data.clear()
	
#	return false #FIXME: remove
	
	var sigs = []
	var l = cli.get_u32()
	var cnt = cli.get_u32()
	for i in range(cnt):
		var s = nwSignal.new()
		var nl = cli.get_u8()
		s.name = cli.get_string(64)
		nl = cli.get_u8()
		s.caption = cli.get_string(128)  #FIXME CHANGE ENCODING
		s.type = cli.get_u8()
		var maxlen  = cli.get_u8()
		for j in s.dims.size():
			s.dims[j] = cli.get_u32()
#		s.resize() #to match dims
		s.io_mode = cli.get_u8()
		s.classified = cli.get_u8()
		sigs.append(s)
	return sigs
	
#ARCHIVE FUNCTIONS SECTION

func sendGetArchiveInfo():
	if not self.srvConnected():
		return false
	
	var size = 0
	var data = PackedByteArray()
	var offset = 0
	
	#no string size
	data.resize(HEADER_SIZE + OP_SIZE)

	offset += HEADER_SIZE;
	data.encode_u8(offset, DAT_ARCHIVE_INFO)
	offset += OP_SIZE
	#real size
	data.encode_u32(0, data.size() - HEADER_SIZE)
	cli.put_data(data)
	
	return false #FIXME: read response
		
	var l = cli.get_u32()
	ar_start_time = cli.get_double()
	ar_end_time = cli.get_double()
	ar_points = cli.get_u64()
	return [ar_start_time, ar_end_time, ar_points]
	
	
func sendGetArchiveData():
	if not self.srvConnected():
		return false
		
	pass
	
func sendGetArchiveEvents():
	if not self.srvConnected():
		return false
		
	pass
