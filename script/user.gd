extends Node

#---------EXTREME-SECTION---------------
#DO NOT TOUCH SALT
const salt = "quater pounder burger"
#DO NOT TOUCH ENUM AND ORDER
enum {ROLE_OPERATOR, ROLE_ENGINEER, ROLE_ADMIN}
#---------EOF-EXTREME-SECTION-----------

#DEBUGGING DEFAULT STATE ADMIN
var user: String = "admin"
var role = ROLE_ADMIN

var user_list = {
	"admin": "3b204559bb4cc5d6414858d6bab0e5517ea8c374056bf329717befd80ed8cece"
}

func getUsers():
	return user_list.keys()
	
func getRole():
	match role:
		ROLE_OPERATOR: return "Оператор"
		ROLE_ENGINEER: return "Инженер"
		ROLE_ADMIN: return "Администратор"
	
func logIn(user, password):
	var hc = [null, null, null]
	var b = null
	for i in hc.size():
		hc[i] = HashingContext.new()
		hc[i].start(HashingContext.HASH_SHA256)
		b = (password + salt + str(i)).to_ascii_buffer()
		hc[i].update(b)
		var hex = hc[i].finish().hex_encode()
		match i:
			ROLE_OPERATOR: print("OP ", hex)
			ROLE_ENGINEER: print("EN ", hex)
			ROLE_ADMIN: print("AD ", hex)
		if user_list[user] == hex:
			self.user = user
			self.role = i
			Log.pwd(user, true)
			return i  #return role	
	Log.pwd(user, false)
	return -1

# Called when the node enters the scene tree for the first time.
func _ready():
	var f = FileAccess.open("./password", FileAccess.READ)
	var d: PackedStringArray
	while not f.eof_reached():
		d = f.get_csv_line(":")
		if d.size() != 2:
			break
		user_list[d[0].strip_edges()] = d[1].strip_edges()
	f = null
	pass # Replace with function body.

func addUser(user, role, hash):
	#TODO: check user exists
	if user in user_list:
		return false
	
	return true
	
func delUser(user):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
