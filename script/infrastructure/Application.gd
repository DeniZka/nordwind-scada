extends Node

@export var state_machine_node: NodePath
@onready var state_machine: StateMachine = get_node(state_machine_node)

func _ready():
	state_machine.to(State.Workplace)
	pass
