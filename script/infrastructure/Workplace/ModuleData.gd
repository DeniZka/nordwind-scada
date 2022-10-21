extends Resource
class_name ModuleData

@export var id: String = "700"
@export var connection: Array[Resource]
@export var update_time_in_sec: float = 1.0
@export var algorithm = "my_diagram"
@export var config = "default.conf"

func get_connection(id: int) -> ConnectionSettings:
	return connection[id] as ConnectionSettings
