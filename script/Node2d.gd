extends Node2D

var password = "password"
var salt = "otdel105"

var salte = "engineer"
var aslto = "operator"
var epass = []
var tpass = []

@export var nextScene = "res://exit.tscn"


var users = {}


func _ready():
	$wrong.modulate.a = 0.0
	"""
	denis:password
	alex:asdfadsf
	"""
	
	
	var ul = User.getUsers()
	ul.sort()
	for u in ul:
		$user.add_item(u)
	return
	
	
func _on_bender_button_down():
	if User.logIn($user.text, $epass.text) >= 0:
		get_tree().change_scene_to_file(nextScene)
	else:
		$epass.text = ""
		$ap.play("blink")
	pass # Replace with function body.


func _on_epass_text_submitted(new_text):
	_on_bender_button_down()
	pass # Replace with function body.
