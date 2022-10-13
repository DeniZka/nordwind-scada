extends Polygon2D

#managed by well main node
var loop_rd = {
	"hello": null,
	"bye": null
}  

var stp_sigs = {
	"delay": null,
	"opentime": null
}

var ctl_sigs = {
	"open": null,
	"close": null
}

var device = "" #701GTV #managed by main device node
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("loop_rd") #read continuous singals updates
	add_to_group("device") 

#called by top level when signals updated (well)
func sigUpdated():
	print("wow! new signal data")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
