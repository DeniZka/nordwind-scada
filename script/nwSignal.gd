class_name nwSignal
extends Object

enum {FLOAT64, CHAR8, INT32, NOT_USED, FLOAT32, FLOAT32_16, INT64, INT16, COMPLEX64_X2, COMPLEX32_X2, COMPLEX32_16_X2, INT8, UINT8, UINT16, UINT32, UINT64}
enum {DIR_READ, DIR_WRITE}

const INVALID_SIGNAL = 255

var dims = [0, 0, 0]
var type = INVALID_SIGNAL
var name: String = ""
var VID = -1

var direction = DIR_READ #or DIR_WRITE
var vals = [] #for multidimensional variables
var val = 0

#info fields
enum {IO_INPUT, IO_OUTPUT, IO_BIDIR, IO_UNKNOWN}
enum {CLSS_EXTERN, CLSS_INTERN, CLSS_STATE, CLSS_DYNAMIC, CLSS_ALGEBRAIC, CLSS_UNKNOWN}
var caption = ""
var io_mode = IO_UNKNOWN
var classified = CLSS_UNKNOWN

func resize():
	var tot_dim = dims[0]
	if dims[1] > 0:
		tot_dim *= dims[1]
	if dims[2] > 0:
		tot_dim *= dims[2]
	vals.resize(tot_dim)
	'''
	vals.resize(dims[0])
	if dims[1] > 0:
		for vx in vals:
			vx = []
			vx.resize(dims[1])
			if dims[2] > 0:
				for vy in vx:
					vy = []
					vy.resize(dims[2])
	'''
func isActive():
	if type == INVALID_SIGNAL:
		return false
	else:
		return true

func _init(sigName: String = "", dir = DIR_READ):
	name = sigName
	if dir == DIR_READ or dir == DIR_WRITE:
		direction = dir
	else:
		dir = DIR_READ
		
func clear():
	
	for i in range(3):
		dims[i] = 0
	#remove variables
	'''
	for vy in vals:
		for vz in vy:
			vz.clear()
		vy.clear()
	'''
	vals.clear()
	type = INVALID_SIGNAL
	var VID = -1
	#TODO: clear values
	
func getBool():
	if vals.size() > 0:
		return vals[0] > 0
		
func getFloat():
	if vals.size() > 0:
		return vals[0]
		
func setFloat(val):
	if vals.size() > 0:
		vals[0] = val
		return true
	else:
		return false
		
func setBool(val):
	if vals.size() > 0:
		vals[0] = int(val)
		return true
	else:
		return false
	
func valsSize():
	match self.type:
		FLOAT64: return vals.size() * 8
		CHAR8: return vals.size() 
		INT32: return vals.size() * 4
		INVALID_SIGNAL: return 0
