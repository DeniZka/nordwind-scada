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
	vals.resize(dims[0] * dims[1] * dims[2] )
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
	