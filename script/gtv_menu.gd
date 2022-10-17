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
#setup edits
@onready var s_opensp = $Pfull_hider/VBhead_body/HBoxContainer/setup_cont/setups/HBoxContainer/SBopensp
@onready var s_closedsp1 = $Pfull_hider/VBhead_body/HBoxContainer/setup_cont/setups/HBoxContainer2/SBclosedsp1
@onready var s_low = $Pfull_hider/VBhead_body/HBoxContainer/setup_cont/setups/HBoxContainer3/SBlow
@onready var s_topen = $Pfull_hider/VBhead_body/HBoxContainer/setup_cont/setups/HBoxContainer4/SBtopen
@onready var s_tclose = $Pfull_hider/VBhead_body/HBoxContainer/setup_cont/setups/HBoxContainer5/SBtclose
@onready var s_remote = $Pfull_hider/VBhead_body/HBoxContainer/setup_cont/setups/HBoxContainer6/SBremote

var GID = "700"
var index = "000"
#multipurpose nordwind
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

var setup_signals = {
	"remote": null,
	"timer_open": null,
	"timer_close": null,
	"open_sp": null,
	"closed_sp1": null,
	"rl_check": null,
	"fl_check": null,
	"password": null
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
		
	self.GID = gid
	self.index = index
	#get Global nordwind signals
	Nw.signalsByDict(GID+"GTV"+index, global_rd)
		
	#show or hide ui parts by role
	if User.role == User.ROLE_OPERATOR:
		engineer_panel.visible = false

		b_lock.visible = false
		b_ulock.visible = true
		b_open.visible = false
		b_close.visible = false
		b_alarm.visible = false 
		

	
	caption_label.text = vlvName
	gtv_img.ValveName = vlvName
#	gtv_img.Index = index
	self.visible = true

func signalsUpdated():
	#skip if not visible
	if not self.visible:
		return
		
	#skip if signals is not loaded
	if global_rd["oc_alarm"] == null:
		return
		
	#read alarm signals from global Nw
	le_oc.visible = global_rd["oc_alarm"].getBool()
	le_pressure.visible = global_rd["pm_alarm"].getBool()
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


func _on_b_open_button_up():
	nw.signalsByDict(GID+"GTV"+index, ctl_rd_signals, nwSignal.DIR_READ)
	nw.signalsByDict(GID+"GTV"+index, ctl_wr_signals, nwSignal.DIR_WRITE)
#	nw.connect()
	pass # Replace with function body.


func _on_b_setupwr_button_up():
	Log.usr("Задание уставок для %s" % GID + "GTV" + index)
	nw.signalsByDict(GID + "GTV" + index, setup_signals,  nwSignal.DIR_WRITE)
	if nw.srvConnect(Nw.ip, Nw.port):
#		Log.log("Подключение к серверу")
		nw.sendInitialization(Nw.init_algo)
		nw.sendSyncVarList()
		setup_signals["timer_open"].setFloat(s_topen.value)
		setup_signals["timer_open"].setFloat(s_tclose.value)
		setup_signals["open_sp"].setFloat(s_opensp.value)
		setup_signals["closed_sp1"].setFloat(s_closedsp1.value)
		setup_signals["remote"].setBool(s_remote.button_pressed)
		nw.sendExchnge()
		nw.srvDisconnect()
	
	#TODO: write setups
	pass # Replace with function body.

func _on_b_setuprd_button_up():
	Log.usr("Чтение уставок для %s" % GID + "GTV" + index)
	nw.signalsByDict(GID + "GTV" + index, setup_signals,  nwSignal.DIR_READ)
	if nw.srvConnect(Nw.ip, Nw.port):
#		Log.log("Подключение к серверу")
		nw.sendInitialization(Nw.init_algo)
		nw.sendSyncVarList()
		nw.sendExchnge()
		for s in setup_signals:
			print(setup_signals[s].vals)
		nw.srvDisconnect()
		
		s_topen.value = setup_signals["timer_open"].getFloat()
		s_tclose.value = setup_signals["timer_open"].getFloat()
		s_opensp.value = setup_signals["open_sp"].getFloat()
		s_closedsp1.value = setup_signals["closed_sp1"].getFloat()
		s_remote.button_pressed = setup_signals["remote"].getBool()
		#read vals
	#TODO: read setups
	pass # Replace with function body.
