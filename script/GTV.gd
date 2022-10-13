extends Node2D

@export var ID: String = "001"

# Called when the node enters the scene tree for the first time.
func _ready():
	set_meta("type", "DCV")
	set_meta("id", ID)
	set_meta("full_id", get_parent().ID + "SCM" + ID)
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

