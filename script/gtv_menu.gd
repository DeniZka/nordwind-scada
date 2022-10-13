extends Control

enum {MD_ENGINEER, MD_OPERATOR}
var mode = MD_ENGINEER
@onready var engineer_panel = $Pfull_hider/VBhead_body/HBoxContainer/setups


# Called when the node enters the scene tree for the first time.
func _ready():
	var nl = get_tree().get_nodes_in_group("GTV")
	for n in nl:
		print(n.connect("show_gtv_menu", Callable(self, "_show_gtv_menu")))
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

func _show_gtv_menu(index):
	print("MOSCOW CALLING")
	$Pfull_hider/VBhead_body/PanelContainer/Label.text = index
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
