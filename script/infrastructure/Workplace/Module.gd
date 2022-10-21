extends Node2D
class_name Device

var module_id: String = ""
var base_nord_wind: MultiNordWind

func construct(module_id: String, nord_wind: MultiNordWind) -> void:
	module_id = module_id
	base_nord_wind = nord_wind
	base_nord_wind.connect("update", _on_signals_updated)
	base_nord_wind.signals_by_dict(get_global_id(), _get_signals(), nwSignal.DIR_READ)
	#base_nord_wind.signalsByDict(get_global_id(), _get_signals(), nwSignal.DIR_READ)
	

func get_global_id() -> String:
	return module_id
	
func _get_signals() -> Dictionary:
	return {"":null}
	
func _on_signals_updated(id: int) -> void:
	pass
