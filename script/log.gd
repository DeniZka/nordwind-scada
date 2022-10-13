extends Node

func _formatdt(OP):
	var dt = Time.get_datetime_dict_from_system()
	return OP + " " + "%02d:%02d:%02d-%02d:%02d:%02d " % [dt.year, dt.month, dt.day, dt.hour,dt.minute,dt.second]

func log(message):
	print(_formatdt("LOG"), message)
	pass
	
func err(message):
	print(_formatdt("ERR"), message)
	pass

func usr(message):
	print(_formatdt("USR"), User.user, " ", message)
	pass
	
func pwd(user, status):
	if status:
		print(_formatdt("USR"), "%s вошел в систему" % [user])
	else:
		print(_formatdt("USR"), "%s неверный пароль" % [user])
	pass
	
func ext(user):
	print(_formatdt("USR"), "%s вышел из системы" % [user])
