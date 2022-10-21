extends State

@export var ui: Node2D

func _enter() -> void:
	print("Enter to Authentication state")
	ui.visible = true
	pass
	
func _exit() -> void:
	ui.visible = false
	print("Exit from Authentication state")
	pass

func _on_login_form_success_login():
	_state_machine.to(State.Workplace)
	pass # Replace with function body.
