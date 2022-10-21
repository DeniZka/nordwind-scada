extends State

@export var workplace: Control
@export var user: Label

func _enter() -> void:
	print("Enter to Workplace state")
	#workplace.visible = true
	#user.text = User.user + " - " + User.getRole()
	pass
	
func _exit() -> void:
	print("Exit from Workplace state")
	#workplace.visible = false
	pass
