extends Control
class_name GTVWindow

@export var caption_label: Label

@export var gtv_engineer_panel_node: NodePath
@onready var gtv_engineer_panel: GTVEngineerPanel = get_node(gtv_engineer_panel_node)

@export var gtv_operator_panel_node: NodePath
@onready var gtv_operator_panel: GTVOperatorPanel = get_node(gtv_operator_panel_node)

@export var connection_id_label: Label

#every time read signals
var global_rd = {
	"interlock": null,
	"pm_alarm": null,
	"oc_alarm": null
}

#operator control signals
var ctl_signals = {
	"open" : null,
	"closed": null
}

#engineer setup signals
var setup_signals = {
	"password": null,
	"remote": null,
	"timer_open": null,
	"timer_close": null,
	"open_sp": null,
	"closed_sp1": null,
	"rl_check": null,
	"fl_check": null
}

var _target_device: Device
var _control_module: ControlModule
var connection_id: int

func open(device: Device, module: ControlModule) -> void:
	_target_device = device
	_control_module = module
	caption_label.text = device.get_global_id()	
	_clearSignalDict(setup_signals)
	_control_module.multi_nord_wind.connect("update", update)
	
	if User.role != User.ROLE_OPERATOR:
		_load_setups(device)
	else:
		gtv_engineer_panel.hide()
		
	visible = true
	pass
	
func close() -> void:
	_control_module.multi_nord_wind.disconnect("update", update)
	connection_id = 0
	visible = false
	pass
	
func update(id: int) -> void:
	print(id)
	pass

func signalsUpdated():		
	if global_rd["oc_alarm"] == null:
		return
		
	gtv_operator_panel.show_alarms(global_rd)
	if global_rd["interlock"].getBool():
		gtv_operator_panel.interlock(User.role)
	else:
		gtv_operator_panel.unlock()


func _clearSignalDict(sdict):
	for k in sdict:
		if sdict[k]:
			sdict[k].clear()
			sdict[k] = null
			
func _on_background_window_gui_input(event):
	if event is InputEventMouseButton && event.button_index == 1 && visible:
		close()
	pass
	
func _on_engineer_panel_load_button_pressed():
	_load_setups(_target_device)
	pass

func _on_engineer_panel_save_button_pressed():
	_write_setups(_target_device)
	pass 
	
func _load_setups(device: Device) -> void:
	var id: String = device.get_global_id()
	_control_module.read(setup_signals, id, connection_id)
	gtv_engineer_panel.write(setup_signals)
	
func _write_setups(device: Device) -> void:
	var id: String = device.get_global_id()
	gtv_engineer_panel.read(setup_signals)
	_control_module.write(setup_signals, id, connection_id)
	pass

func _on_main_connection_button_pressed():
	connection_id = 0
	connection_id_label.text = "Соединение по основной линии"
	_load_setups(_target_device)
	pass # Replace with function body.

func _on_reserve_connection_button_pressed():
	connection_id = 1
	connection_id_label.text = "Соединение по резервной линии"
	_load_setups(_target_device)
	pass # Replace with function body.
