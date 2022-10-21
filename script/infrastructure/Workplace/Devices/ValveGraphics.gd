extends Node2D
class_name ValveGraphics

@export var left: Polygon2D
@export var right: Polygon2D

const clr_open = Color.DARK_GREEN
const clr_close = Color.ORANGE_RED
const clr_unknown = Color.GRAY

func close() -> void:
	right.color = clr_close
	left.color = clr_close
	pass
	
func open() -> void:
	right.color = clr_open
	left.color = clr_open
	pass
	
func unknown() -> void:
	right.color = clr_unknown
	left.color = clr_unknown
	pass
