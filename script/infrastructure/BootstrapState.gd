extends State

func _enter() -> void:
	print("Enter to Bootstrap state")
	_state_machine.to(State.Authentication)
	pass
	
func _exit() -> void:
	print("Exit from Bootstrap state")
	pass
