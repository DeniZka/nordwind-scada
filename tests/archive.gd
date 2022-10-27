extends Node2D

@onready var arch: NordWind = NordWind.new()

var sd = {
	"curr_loop_0_val": null,
	"curr_loop_1_val": null
}

var l = []
# Called when the node enters the scene tree for the first time.
func _ready():
	arch.srvConnect("192.168.100.40",  32375)
#	var info = arch.sendGetArchiveInfo()
	arch.sendInitialization("archive")  #00
	#arch.sendGetAvailableVarList()	#FIXME: fix cant load after initialization #0A
	#l = arch.sendGetArchiveInfo() #0b
	#01
	arch.signalsByDict("sens", sd)
	arch.sendSyncVarList()
	l = arch.sendGetArchiveInfo() #0b
	arch.sendGetArchiveData(l[1], l[1]-l[0], l[2])
	arch.srvDisconnect()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
