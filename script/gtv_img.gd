@tool
extends Node2D


var vlvName = ""
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

@onready var not_opened = $unrotator/Control/not_opened
@onready var not_closed = $unrotator/Control/not_closed

signal show_gtv_menu 

# Called when the node enters the scene tree for the first time.
func _ready():
	if $Label:
		$Label.type = "AMV"
	setState(ST_UNKNOWN)
	setMode(MD_MANUAL)
	#signal
	add_to_group("GTV")
	pass # Replace with function body.

func setState(state):
	$Light.visible = false
	not_opened.visible = false
	not_closed.visible = false
	match state:
		ST_UNKNOWN:
			$right.color = Color.GRAY
			$left.color = Color.GRAY
			$top.color = Color.GRAY
		ST_OPEN:
			$right.color = Color.DARK_GREEN
			$left.color = Color.DARK_GREEN
			$top.color = Color.DARK_GREEN
		ST_CLOSE:
			$right.color = Color.ORANGE
			$left.color = Color.ORANGE
			$top.color = Color.ORANGE
		ST_OPENING:
			$right.color = Color.GRAY
			$left.color = Color.GRAY
			$top.color = Color.DARK_GREEN
		ST_CLOSING:
			$right.color = Color.GRAY
			$left.color = Color.GRAY
			$top.color = Color.ORANGE
		ST_UNOPENED_START:
			$right.color = Color.ORANGE
			$left.color = Color.ORANGE
			$top.color = Color.DARK_GREEN
			$Light.visible = true
			not_opened.visible = true
			#FIXME: error
		ST_UNCLOSED_START:
			$right.color = Color.DARK_GREEN
			$left.color = Color.DARK_GREEN
			$top.color = Color.ORANGE
			$Light.visible = true
			not_closed.visible = true
			#FIXME: error
		ST_UNOPENED_PROC:
			$right.color = Color.GRAY
			$left.color = Color.GRAY
			$top.color = Color.DARK_GREEN
			$Light.visible = true
			not_opened.visible = true
			#FIXME: error
		ST_UNCLOSED_PROC:
			$right.color = Color.GRAY
			$left.color = Color.GRAY
			$top.color = Color.ORANGE
			$Light.visible = true
			not_closed.visible = true
			#FIXME: error
		
func setMode(mode):
	if has_node("Label"):
		if mode == MD_MANUAL:
			$Label.mode = "Р"
		if mode == MD_REMOTE:
			$Label.mode = "У"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if rotation:
		$unrotator.rotation = -rotation
	pass


func _on_click_sens_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.button_mask == 0:
			emit_signal("")
	pass # Replace with function body.


func _on_click_sens_mouse_entered():
	print("MOUSE ENTERED")
	pass # Replace with function body.
