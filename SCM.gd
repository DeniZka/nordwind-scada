extends Node2D
var busy = false  #SCM is BUSY
var ID = ""
var nw_ctl: NordWind = null #control (open/close) NW connection
var nw_stp_rd: NordWind = null #read setups (ustavki) NW connection
var nw_stp_wr: NordWind = null #write setups connection
var ip = "0.0.0.0"
var port = 22375

# Called when the node enters the scene tree for the first time.
func _ready():
	ID = get_parent().ID + str(name)
	print("Fullid ", ID)
	add_to_group("clients")
	nw_ctl = NordWind.new()
	nw_stp_rd = NordWind.new()
	nw_stp_wr = NordWind.new()
	#set self group for needed childrens
	var ns = get_tree().get_nodes_in_group("device")
	for n in ns:
		#set self as a group only for nodes that in sub
		if str(get_path()) in str(n.get_path()):
			n.device = ID
		
	ns = get_tree().get_nodes_in_group("ctl_button")
	for n in ns:
		if n.device == ID:
			n.connect("ctl_button_pressed", Callable(self, "_on_ctl_button_down"))
			print(n, n.device)
			
func setNwHost(ip, port):
	self.ip = ip
	self.port = port
	
func _on_ctl_button_down(val):
	if val:
		print("BTTON DOWN")
		#press btn 
		#send apply data
		pass
	else:
		print("BUTTON UP")
		#released button
		#send apply data
		pass
	pass
	
func _on_setup_button_pressed(val):
	if val:
		pass
	else:
		pass

func setServer(ip, port = 22375):
	self.ip = ip
	self.port = port

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
