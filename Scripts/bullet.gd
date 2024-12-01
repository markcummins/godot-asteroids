extends Area2D

class_name Bullet

var direction: Vector2

@export var bullet_speed = 700

@onready var audio_shoot: AudioStreamPlayer2D = $AudioShoot

func _ready() -> void:
	audio_shoot.play()

func _process(delta):
	position += direction * bullet_speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
