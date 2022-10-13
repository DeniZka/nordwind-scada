extends Node2D

@export var ID: String = "001"
var nw_ctl: NordWind = null
var nw_stp: NordWind = null

# Called when the node enters the scene tree for the first time.
func _ready():
	set_meta("type", "DCV")
	set_meta("id", ID)
	set_meta("full_id", get_parent().ID + "SCM" + ID)

	print("GTV_ready")
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

