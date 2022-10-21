extends RefCounted
class_name MultiNordWind

signal update(connection_id: int)

var first_nord_wind: NordWind
var second_nord_wind: NordWind

var moduleData: ModuleData

var update_timer: float
var update_target_time: float

func _init(moduleData: ModuleData) -> void:
	self.moduleData = moduleData
	update_target_time = moduleData.update_time_in_sec
	
func connect_to_server() -> void:
	if first_nord_wind != null:
		clean()
	
	first_nord_wind = NordWind.new()
	second_nord_wind = NordWind.new()
	var initialization = moduleData.algorithm + "#" + moduleData.config
	var first_connection = moduleData.get_connection(0)
	var second_connection = moduleData.get_connection(1)
	_connect_to_server(first_nord_wind, first_connection, initialization, 0)
	_connect_to_server(second_nord_wind, second_connection, initialization, 1)
	
	connect_all()
	pass
	
func signals_by_dict(id: String, signals1: Dictionary, signals2: Dictionary, direction: Variant) -> void:
	first_nord_wind.signalsByDict(id, signals1, direction)
	second_nord_wind.signalsByDict(id, signals2, direction)
	pass
	
static func _connect_to_server(nord_wind: NordWind, connection: ConnectionSettings, initialization: String, id: int) -> void:
	if nord_wind.srvConnect(connection.ip, connection.port):
		var result = nord_wind.sendInitialization(initialization)
		if result and result[0] == 0:
			print("Initialization NordWind %d success!" % id)
	pass
	
func send_sync_var_list() -> void:
	first_nord_wind.sendSyncVarList()
	second_nord_wind.sendSyncVarList()
	pass
	
func process(delta: float) -> void:
	update_timer += delta
	if (update_timer >= update_target_time):
		update_timer = 0
		send_exchange()	
	pass
	
func send_exchange() -> void:
	print("SEND EXCHANGE!")
	first_nord_wind.sendExchnge()
	second_nord_wind.sendExchnge()
	
	print("NORDWIND #0 connection: " + str(first_nord_wind.srvConnected()))
	print("NORDWIND #1 connection: " + str(second_nord_wind.srvConnected()))
	
	pass
	
func connect_all() -> void:
	first_nord_wind.connect("signalsUpdated", _on_first_updated)
	second_nord_wind.connect("signalsUpdated", _on_second_updated)
	pass
	
func disconnect_all() -> void:
	first_nord_wind.disconnect("signalsUpdated", _on_first_updated)
	second_nord_wind.disconnect("signalsUpdated", _on_second_updated)
	pass
	
func clean() -> void:
	disconnect_all()
	first_nord_wind.free()
	second_nord_wind.free()
	pass
	
func _on_first_updated() -> void:
	_emit_update(0)
	pass
	
func _on_second_updated() -> void:
	_emit_update(1)
	pass
	
func _emit_update(id: int) -> void:
	emit_signal(str(update.get_name()), id)
	pass
