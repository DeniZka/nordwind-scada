@tool
extends Device

var vlvName = "GTV"
@export var ValveName = "GTV":
	get:
		return vlvName
	set(val):
		vlvName = val
		if has_node("Label"):
			$Label.type = val
			

@export var index = "001"

enum {
	ST_UNKNOWN, 
	ST_OPEN, ST_CLOSE, 
	ST_OPENING, ST_CLOSING, 
	ST_UNOPENED_START, ST_UNCLOSED_START,
	ST_UNOPENED_PROC, ST_UNCLOSED_PROC
}
enum {MD_MANUAL, MD_REMOTE}

@export var valve_graphics_node: NodePath
@onready var valve_graphics: ValveGraphics = get_node(valve_graphics_node) as ValveGraphics

@export var alarm_node: NodePath
@onready var alarm: ValveAlarm = get_node(alarm_node) as ValveAlarm

signal show_gtv_menu 
signal show_menu(device: Device)

#read self global signals
var signals = {
	"open_rem": null,  #сигнал открытия дошел
	"close_rem": null, #сигнал закрытия дошел
	"open": null,      #открыт
	"closed": null,    #акрыт
	"oc_alarm": null,  #не открылся
	"pm_alarm": null,  #не перерасход жидкости
	"remote": null,
	#preload other needed signal for opening menu pre ready signals
	"interlock": null
	#TODO: complete list
}
	
func get_global_id() -> String:
	return module_id + vlvName + index
	
func _get_signals() -> Dictionary:
	return signals
	
func _on_signals_updated(id: int) -> void:
	signalsUpdated()
	pass
		
func signalsUpdated():
	setMode(int(signals["remote"].getBool()))
		
	#check any of action is finished
	if signals["open"].getBool():
		valve_graphics.open()
	elif signals["closed"].getBool():
		valve_graphics.close()
	else:
		valve_graphics.unknown()
	
	#check no alarm (reset them)
	if not signals["oc_alarm"].getBool():
		alarm.hide()
	else:
		alarm.show()
		alarm.show_label(signals["open"], signals["closed"])
			
	if has_node("Label"):
		$Label.locked = signals["interlock"].getBool()
	

func setMode(mode):
	if has_node("Label"):
		if int(mode) == MD_MANUAL:
			$Label.mode = "Р"
		if int(mode) == MD_REMOTE:
			$Label.mode = "У"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if rotation:
		$unrotator.rotation = -rotation
	pass

func _on_click_trigger_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.button_mask == 0:
			emit_signal(str(show_menu.get_name()), self)
	pass # Replace with function body.
