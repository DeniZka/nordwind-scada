extends Node2D
class_name ValveAlarm

@export var light: Sprite2D
@export var not_opened_label: Label
@export var not_closed_label: Label

func show() -> void:
	light.show()
	pass
	
func show_label(is_opened: bool, is_closed: bool) -> void:
	not_opened_label.visible = is_opened
	not_closed_label.visible = is_closed
	
func hide() -> void:
	light.hide()
	not_opened_label.hide()
	not_closed_label.hide()
	self.hide()
	pass
