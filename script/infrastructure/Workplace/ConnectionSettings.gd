extends Resource
class_name ConnectionSettings

@export var ip: String = "192.168.100.40"
@export_range(0, 65535) var port: int = 22375
