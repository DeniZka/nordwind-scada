extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_hint_mouse_exited():
#	visible = false
	pass # Replace with function body.


func _on_win_close_button_up():
	visible = false
	$"../Valve".scale = Vector2(1, 1)
	pass # Replace with function body.
