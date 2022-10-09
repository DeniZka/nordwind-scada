extends Node

func log(message):
	var dt = Time.get_datetime_dict_from_system()
	print("%02d:%02d:%02d-%02d:%02d:%02d " % [dt.year, dt.month, dt.day, dt.hour,dt.minute,dt.second], message)
	pass
