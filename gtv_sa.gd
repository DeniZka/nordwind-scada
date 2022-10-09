extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_sens_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		var e: InputEventMouseButton
		if event.button_index == MOUSE_BUTTON_LEFT:
			$"../Valve".scale = Vector2(2, 2)
			$"../hint".visible = true
		print(event)
	pass # Replace with function body.
