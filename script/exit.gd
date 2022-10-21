extends Node2D

var speed = 15
# Called when the node enters the scene tree for the first time.
func _ready():
	$ap.play("fly")
	$words.play("words")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label.position.y -=  speed * delta
	pass
	
func _input(event):
	if event is InputEventKey:
		print(event.keycode)
		if event.keycode == KEY_ESCAPE:
			get_tree().change_scene_to_file("res://node_2d.tscn")
