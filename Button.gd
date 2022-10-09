extends Button

var sig: nwSignal = null
var nw: NordWind = null
# Called when the node enters the scene tree for the first time.
func _ready():
	nw = NordWind.new()
	sig = nwSignal.new(str(name), nwSignal.DIR_WRITE)
	nw.addVar(sig)
	pass # Replace with function body.

func _exit_tree():
	nw.free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_pressed():
	Log.log("hello guys")
	nw.srvConnect("192.168.31.54")
	var res = nw.sendExec(str(name))
	nw.srvDisconnect()
#	nw.sendSyncVarList()
	print("stat: ", res[0], " crc: ", res[1])
	pass # Replace with function body.
