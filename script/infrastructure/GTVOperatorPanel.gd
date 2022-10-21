extends PanelContainer
class_name GTVOperatorPanel

@export var alarm_le_oc: Label
@export var alarm_le_pressure: Label
@export var alarm_le_liquid: Label
@export var alarm_le_failure: Label
@export var unlock_password_field: LineEdit

@export var block_button: Button
@export var unlock_container: Container

@export var open_button: Button
@export var close_button: Button
@export var alarm_button: Button

func show_alarms(alarms: Dictionary) -> void:
	alarm_le_oc.visible = alarms["oc_alarm"].getBool()
	alarm_le_pressure.visible = alarms["pm_alarm"].getBool()
	pass 

func interlock(role: int) -> void:
	unlock_container.visible = true
	block_button.visible = false
	if role == User.ROLE_OPERATOR: 
		open_button.visible = false
		close_button.visible = false
		alarm_button.visible = false 
		
func unlock() -> void:
	unlock_container.visible = false
	block_button.visible = true
	open_button.visible = true
	close_button.visible = true
	alarm_button.visible = true 

func reset_alarms() -> void:
	alarm_le_oc.hide()
	alarm_le_pressure.hide()
	alarm_le_liquid.hide()
	alarm_le_failure.hide()
	pass

func _on_reset_alarms_button_pressed():
	reset_alarms()
	pass # Replace with function body.

func _on_open_button_pressed():
	pass # Replace with function body.
