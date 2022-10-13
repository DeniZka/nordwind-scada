extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	Log.log("---SCADA---loading---done--------")
	$"701/GTVimg".setState($"701/GTVimg".ST_UNOPENED_PROC)
	pass
	#'''	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#check connection is present
	return
	
	
	pass
