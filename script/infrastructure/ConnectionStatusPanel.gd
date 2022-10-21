extends Control
class_name ConnectionStatusPanel

@export var main_connection: Label
@export var reserve_connection: Label

var nord_wind: MultiNordWind

func follow(nord_wind: MultiNordWind) -> void:
	self.nord_wind = nord_wind
	self.nord_wind.connect("update", _on_update)
	pass
	
func _on_update(id: int) -> void:
	if nord_wind.first_nord_wind.srvConnected():
		main_connection.modulate = Color.GREEN
	else:
		main_connection.modulate = Color.RED
		
	if nord_wind.second_nord_wind.srvConnected():
		reserve_connection.modulate = Color.GREEN
	else:
		reserve_connection.modulate = Color.RED
	pass
