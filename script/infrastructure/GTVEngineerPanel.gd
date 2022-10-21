extends PanelContainer
class_name GTVEngineerPanel

signal load_button_pressed
signal save_button_pressed

@export var pressure_open_field: SpinBox
@export var pressure_closed_field: SpinBox
@export var low_pressure_field: SpinBox
@export var time_open_field: SpinBox
@export var time_close_field: SpinBox
@export var remote_control_checkbox: CheckBox
@export var password_field: LineEdit

func read(signals: Dictionary) -> void:
	signals["timer_open"].setFloat(time_open_field.value)
	signals["timer_close"].setFloat(time_close_field.value)
	signals["open_sp"].setFloat(pressure_open_field.value)
	signals["closed_sp1"].setFloat(pressure_closed_field.value)
	signals["remote"].setBool(remote_control_checkbox.button_pressed)
	
func write(signals: Dictionary) -> void:
	time_open_field.value = signals["timer_open"].getFloat()
	time_close_field.value = signals["timer_close"].getFloat()
	pressure_open_field.value = signals["open_sp"].getFloat()
	pressure_closed_field.value = signals["closed_sp1"].getFloat()
	remote_control_checkbox.button_pressed = signals["remote"].getBool()

func _on_save_setup_button_pressed():
	print("Password: " + password_field.text)
	emit_signal(str(save_button_pressed.get_name()))
	pass 

func _on_load_setup_button_pressed():
	emit_signal(str(load_button_pressed.get_name()))
	pass
