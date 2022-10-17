extends Node2D

@export var ID: String = "700"
@export var A_IP: String = "192.168.100.40"
@export_range(0, 65535) var A_PORT = 22375
@export var B_IP: String = "192.168.100.41"
@export_range(0, 65535) var B_PORT = 22375
@export var Exchange_Timeout_Us = 1000
@onready var nw: NordWind = null

var pre_sigs = [] #prevously ready signals

var tcnt = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_meta("type", "root")
	set_meta("id", ID)
	#create NordWind client
	nw = NordWind.new()
	if nw.srvConnect(A_IP, A_PORT):
		var init_res = nw.sendInitialization("my_diagram#default.conf")
		if init_res and init_res[0] == 0:
			print("initialization ok")
#	nw.srvDisconnect()
	#serach for any singal subscribers
	var nodes = get_tree().get_nodes_in_group("signals")
	for n in nodes:
		for s in n.loop_rd:
			n.loop_rd[s] = subscribeRdSignal(n.device, s)
			
	#set self global id for devices
	var nl = get_tree().get_nodes_in_group("device")
	for n in nl:
		if n.has_method("setGlobalId"):
			n.setGlobalId(str(name))
	
	#register signal in nordwind
	for s in pre_sigs:
		nw.addVar(s)
		
	

func subscribeRdSignal(id, sig):
	#full signal name
	var fsn = id + "_" + sig
	
	#check signal is in NwList
	if nw:
		var sn = nw.findRdSignal(fsn)
		if sn: 
			return sn
		
	#check signal already is in request list
	for s in pre_sigs:
		if s.name == fsn:
			return s
			
	#no signal found add new
	var sn = nwSignal.new(fsn)
	if nw:
		nw.addVar(sn)
	else:
		pre_sigs.append(sn)
	return sn
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	tcnt += delta
	if tcnt >= Exchange_Timeout_Us:
		nw.sendExchnge()
		var ns = get_tree().call_group("loop_rd", "sigUpdated")
		ns
	pass
