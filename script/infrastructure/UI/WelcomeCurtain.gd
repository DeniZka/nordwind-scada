extends Node2D

@export var fly_animation: AnimationPlayer
@export var words_animation: AnimationPlayer

@export var titles: Label
@export var titles_speed: int = 15

func _ready():
	fly_animation.play("fly")
	words_animation.play("words")
	pass

func _process(delta):
	titles.position.y -= titles_speed * delta
	pass
