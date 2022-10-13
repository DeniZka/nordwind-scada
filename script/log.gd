extends Node

func log(message):
	var dt = Time.get_datetime_dict_from_system()
	print("%02d:%02d:%02d-%02d:%02d:%02d " % [dt.year, dt.month, dt.day, dt.hour,dt.minute,dt.second], message)
	pass

func actionlog(message):
	var dt = Time.get_datetime_dict_from_system()
	print("%02d:%02d:%02d-%02d:%02d:%02d %s " % [dt.year, dt.month, dt.day, dt.hour,dt.minute,dt.second, User.user], message)
	pass
	
func loginLog(user, status):
	var dt = Time.get_datetime_dict_from_system()
	if status:
		print("%02d:%02d:%02d-%02d:%02d:%02d %s вошел в систему" % [dt.year, dt.month, dt.day, dt.hour,dt.minute,dt.second, user])
	else:
		print("%02d:%02d:%02d-%02d:%02d:%02d %s указан неверный пароль" % [dt.year, dt.month, dt.day, dt.hour,dt.minute,dt.second, user])
	pass
