extends Container

signal success_login

@export var username: OptionButton
@export var password: LineEdit
@export var invalid_password: Label

func _ready():
	invalid_password.modulate.a = 0
	for user in User.getUsers():
		username.add_item(user)

func _on_login_button_pressed():
	if _isSuccess(username.text, password.text):
		emit_signal(str(success_login.get_name()))
	else:
		_show_invalid_message()
	pass 
	
func _isSuccess(username: String, password: String) -> bool:
	return User.logIn(username, password) >= 0
	
func _show_invalid_message() -> void:
	const colorProperty: String = "modulate"
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(invalid_password, colorProperty, Color.RED, 0.2)
	tween.tween_property(invalid_password, colorProperty, Color(1, 0, 0, 0), 0.2).set_delay(1)
