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


# Called when the node enters the scene tree for the first time.
func _ready():
	var nl = get_tree().get_nodes_in_group("GTV")
	for n in nl:
		n.connect("show_gtv_menu", Callable(self, "_show_gtv_menu"))
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if engineer_panel and User.role == User.ROLE_OPERATOR:
		engineer_panel.visible = false


func _on_hint_mouse_exited():
#	visible = false
	pass # Replace with function body.


func _on_win_close_button_up():
	visible = false
	$"../Valve".scale = Vector2(1, 1)
	pass # Replace with function body.

func _show_gtv_menu(gid, index, vlvName):
	if not self.visible:
		caption_label.text = vlvName
		gtv_img.ValveName = vlvName
	#	gtv_img.Index = index
		self.visible = true
	pass

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
