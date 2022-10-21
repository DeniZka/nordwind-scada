extends Node
class_name State

const Bootstrap: String = "Bootstrap"
const Authentication: String = "Authentication"
const Workplace: String = "Workplace"

var _state_machine: StateMachine

func _enter() -> void:
	print("Enter to STATE")
	pass

func _exit() -> void:
	print("Exit from STATE")
	pass
