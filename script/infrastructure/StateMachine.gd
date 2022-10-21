extends Node
class_name StateMachine

@onready var current: State = State.new()

func _ready():
	_init_child_states()
	pass

func _init_child_states():
	for child in get_children():
		child._state_machine = self
	pass
		
func to(state: String) -> void:
	current._exit()
	current = get_node(state)
	current._enter()
	pass
