@tool
extends Polygon2D
class_name DevLabel


@export var type = "GTV":
	get:
		if has_node("type"):
			return $type.text
		else:
			return ""
	set(val):
		if has_node("type"):
			$type.text = val
		
@export var mode = "А":
	get:
		if has_node("mode"):
			return $mode.text
		else:
			return ""
	set(val):
		if has_node("mode"):
			$mode.text = val

@export var locked: bool = false:
	get:
		if has_node("lock"):
			return $lock.visible
		else:
			return false
	set(val):
		if has_node("lock"):
			$lock.visible = val

# Called when the node enters the scene tree for the first time.
func _ready():
	print("READ")
	pass # Replace with function body.

func setMode(mode):
	$mode.text = mode
	pass
	
func setIndex(index):
	$id.text = index
	pass
	
func setLock(lock):
	lock.visible = lock
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
