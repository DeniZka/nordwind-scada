extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	print("READY")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_button_up():
	queue_free()
	pass # Replace with function body.
