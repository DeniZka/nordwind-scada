extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum {RS_WAIT_HEADER, RS_READ_BODY, RS_PARSE_DATA}
const DAT_EXEC = 9

var srv: TCPServer = null
var cli: StreamPeerTCP = null
var rcv_state = RS_WAIT_HEADER
var packet_size = 0
var op = -1
var data: PackedByteArray = []


# Called when the node enters the scene tree for the first time.
func _ready():
	print("NV REady")
	srv = TCPServer.new()
	srv.listen(22375, "192.168.31.54")
	print("server started ", srv.is_listening())
	var t = Thread.new()
	t.start(Callable(self, "thrd"))
	print("thread is ", t.is_started())
	pass # Replace with function body.


func thrd():
	
	while true:
		#accept connection
		if (srv.is_connection_available()):
			cli = srv.take_connection()
			cli.set_no_delay ( true ) #???? need????
			print("connection taken")
		
		#check client is
		if not cli:
			continue
		
		#check client is online
		cli.poll()
		if cli.get_status() == StreamPeerTCP.STATUS_NONE:
			print("client disconnected")
			cli = null
			continue
		
		#read data
		var abytes = cli.get_available_bytes()
		match (rcv_state):
			RS_WAIT_HEADER:
				if abytes >= 4:
					packet_size = cli.get_u32()
					print("header received ", packet_size)
					rcv_state = RS_READ_BODY
			RS_READ_BODY:
				op = cli.get_u8()
				print("op - ", op)
				rcv_state = RS_PARSE_DATA
			RS_PARSE_DATA:
				match (op):
					DAT_EXEC:
						var l = cli.get_u32()
						var s = cli.get_string(l)
						print(s)
						var sd = PackedByteArray()
						sd.resize(4+1+4)
						sd.encode_u32(0, 5)
						sd.encode_u8(4, 1)
						sd.encode_u32(5, 65535)
						cli.put_data(sd)
						rcv_state = RS_WAIT_HEADER
				
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	pass
