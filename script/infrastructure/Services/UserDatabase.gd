extends Resource
class_name UserDatabase

var users = {
	"denis": "password",
	"alex":"alex",
	"admin": "3b204559bb4cc5d6414858d6bab0e5517ea8c374056bf329717befd80ed8cece"
}

func Users() -> Array:
	return users.keys()
