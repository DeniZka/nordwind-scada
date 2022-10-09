extends Button

#signal for device connection and read changes
#when buttons are pressed send 1 for signal and when released sends 0
signal ctl_button_pressed
#when buton is pressed read actual setups
#signal stp_wr_button_pressed
#when button is pressed signals are 
#signal stp_rd_button_pressed

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

var upd_sigs = false
var device = "" #701GTV #managed by main device node
# Called when the node enters the scene tree for the first time.
func _ready():
	#add_to_group("loop_rd") #read continuous singals updates
	add_to_group("stp_sigs") #setup signal for read and for set
	add_to_group("ctl_sigs") #control signal (mainly open and close)
	add_to_group("device") #signals are parts of one of parent device 
	add_to_group("ctl_button") #is control button
#	add_to_group("stp_wr_button") #is setup button
#	add_to_group("stp_rd_button") #is setup button

#called by root node (well) when got new signals
func sigUpdated(sig_list = 0):
	if sig_list == 0:
		print("wow! new loop signal data")
	else:
		print("setup signals are updated")
		
func _process(delta):
	pass

func _on_button_button_down():
	emit_signal("ctl_button_pressed", 1)
#	emit_signal("stp_wr_button_pressed", 1)
#	emit_signal("stp_rd_button_pressed", 1)
	

func _on_button_button_up():
	emit_signal("ctl_button_pressed", 0)
#	emit_signal("stp_wr_button_pressed", 0)
#	emit_signal("stp_rd_button_pressed", 0)
	
