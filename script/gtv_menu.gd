extends Control

enum {MD_ENGINEER, MD_OPERATOR}
var mode = MD_ENGINEER
@onready var engineer_panel = $Pfull_hider/VBhead_body/HBoxContainer/setup_cont
@onready var caption_label = $Pfull_hider/VBhead_body/PanelContainer/Label
@onready var gtv_img = $Pfull_hider/VBhead_body/HBoxContainer/PanelContainer2/VBoxContainer/HBoxContainer/Indic/PanelContainer2/Cadjust/GTVimg
@onready var le_oc = $Pfull_hider/VBhead_body/HBoxContainer/PanelContainer2/VBoxContainer/HBoxContainer/alarms/LE_OC
@onready var le_pressure = $Pfull_hider/VBhead_body/HBoxContainer/PanelContainer2/VBoxContainer/HBoxContainer/alarms/LE_PRESSURE
@onready var le_hidraulic = $Pfull_hider/VBhead_body/HBoxContainer/PanelContainer2/VBoxContainer/HBoxContainer/alarms/LE_LIQUID
@onready var le_failure = $Pfull_hider/VBhead_body/HBoxContainer/PanelContainer2/VBoxContainer/HBoxContainer/alarms/LE_FAILURE
@onready var b_open = $Pfull_hider/VBhead_body/HBoxContainer/PanelContainer2/VBoxContainer/rule/BOpen
@onready var b_close = $Pfull_hider/VBhead_body/HBoxContainer/PanelContainer2/VBoxContainer/rule/BClose
@onready var b_alarm = $Pfull_hider/VBhead_body/HBoxContainer/PanelContainer2/VBoxContainer/rule/BAlarms
@onready var b_lock = $Pfull_hider/VBhead_body/HBoxContainer/PanelContainer2/VBoxContainer/rule/BLock
@onready var b_ulock = $Pfull_hider/VBhead_body/HBoxContainer/PanelContainer2/VBoxContainer/rule/HBUnlock

var nw: NordWind = null
var global_rd = {
	"interlock": null,
	"pm_alarm": null,
	"oc_alarm": null
}

var ctl_rd_signals = {
	"open" : null,
	"closed": null
}
var ctl_wr_signals = {
	"open": null,
	"closed": null
}

var nw_setup: NordWind = null
var setup_rd_signal = {
	"password" = null
}
var setup_wr_signal = {
	"password" = null
}

# Called when the node enters the scene tree for the first time.
func _ready():
	if Nw:
		#connect to global Nw
		Nw.connect("signalsUpdated", Callable(self, "signalsUpdated"))
		
	nw = NordWind.new()
	
	var nl = get_tree().get_nodes_in_group("GTV")
	for n in nl:
		n.connect("show_gtv_menu", Callable(self, "_show_gtv_menu"))
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_hint_mouse_exited():
#	visible = false
	pass # Replace with function body.


func _on_win_close_button_up():
	visible = false
	$"../Valve".scale = Vector2(1, 1)
	pass # Replace with function body.

#show this menu with new selected GTV configuration
func _show_gtv_menu(gid, index, vlvName):
	if self.visible:
		return
		
	#show or hide ui parts by role
	if User.role == User.ROLE_OPERATOR:
		engineer_panel.visible = false

		b_lock.visible = false
		b_ulock.visible = true
		b_open.visible = false
		b_close.visible = false
		b_alarm.visible = false 
		
	
	Nw.signalsByDict(gid + "GTV" + index, global_rd)
	
	caption_label.text = vlvName
	gtv_img.ValveName = vlvName
#	gtv_img.Index = index
	self.visible = true

func signalsUpdated():
	#skip if not visible
	if not self.visible:
		return
		
	#read alarm signals from global Nw
	if global_rd["oc_alarm"].getBool():
		le_oc.visible = true
	if global_rd["pm_alamr"].getBool():
		le_pressure.visible = true
	if global_rd["interlock"].getBool():
		b_ulock.visible = true
		b_lock.visible = false
		if User.role == User.ROLE_OPERATOR: 
			b_open.visible = false
			b_close.visible = false
			b_alarm.visible = false 
	else:
		b_ulock.visible = false
		b_lock.visible = true
		b_open.visible = true
		b_close.visible = true
		b_alarm.visible = true 
	

func _on_gtv_menu_mouse_entered():
	print("Mouse Entered")
	pass # Replace with function body.


func _on_gtv_menu_mouse_exited():
	print("Mouse Exited")
	pass # Replace with function body.


func _on_pfull_hider_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			visible = false
	pass # Replace with function body.


func _on_b_alarms_button_up():
	le_oc.visible = false
	le_pressure.visible = false
	le_hidraulic.visible = false
	le_failure.visible = false
	pass # Replace with function body.
