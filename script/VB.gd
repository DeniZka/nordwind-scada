extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	#close
	_on_button_button_down()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_button_down():
	if $"../Button".text == "<":
		visible = false
		$"../Button".text = ">"
	else:
		visible = true
		$"../Button".text = "<"
		
	pass # Replace with function body.


func _on_exit_button_up():
	get_tree().change_scene_to_file("res://exit.tscn")
	pass # Replace with function body.
