extends Node2D
class_name ControlModule

@export var data: Resource
@onready var moduleData: ModuleData = data as ModuleData

@export var gtv_window_node: NodePath
@onready var gtv_window: GTVWindow = get_node(gtv_window_node)

@export var connection_panel_node: NodePath
@onready var connection_panel: ConnectionStatusPanel = get_node(connection_panel_node)

var connection_timer: float = 0
var multi_nord_wind: MultiNordWind

func _ready() -> void:
	multi_nord_wind = MultiNordWind.new(moduleData)
	multi_nord_wind.connect_to_server()
	_init_devices(moduleData.id, multi_nord_wind)
	multi_nord_wind.send_sync_var_list()
	connection_panel.follow(multi_nord_wind)
	pass
	
func _process(delta: float) -> void:
	multi_nord_wind.process(delta)
	pass

func _init_devices(module_id: String, nord_wind: MultiNordWind) -> void:
	for child in get_children():
		if (child is Device):
			child.construct(module_id, nord_wind)
			child.connect("show_menu", _on_show_menu)
	pass
		
func _on_show_menu(device: Device) -> void:
	Log.usr("Открыл окно управления для " + device.get_global_id())
	gtv_window.open(device, self)
	pass
	
func write(data: Dictionary, id: String, connection_id: int = 0) -> void:
	Log.usr("Задание уставок для %s" % id)
	var connection = moduleData.get_connection(connection_id)
	_exchange(data, id, connection.ip, connection.port, nwSignal.DIR_WRITE)	
	pass

func read(data: Dictionary, id: String, connection_id: int = 0) -> void:
	Log.usr("Чтение уставок для %s" % id)
	print(id + ";" + str(connection_id))
	var connection = moduleData.get_connection(connection_id)
	_exchange(data, id, connection.ip, connection.port, nwSignal.DIR_READ)	
	pass

static func _exchange(data: Dictionary, id: String, ip: String, port: int, direction: int) -> void:
	var nordWind = NordWind.new()
	nordWind.signalsByDict(id, data, direction)
	if nordWind.srvConnect(ip, port):
		nordWind.sendInitialization(Nw.init_algo)
		nordWind.sendSyncVarList()
		nordWind.sendExchnge()
		nordWind.srvDisconnect()
	nordWind.free()
	pass
