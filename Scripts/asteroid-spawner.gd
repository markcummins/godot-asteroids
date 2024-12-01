extends Node

class_name AsteroidSpawner

@export var asteroid_scene: PackedScene
@export var count = 6

@onready var explosion_audio_player: AudioStreamPlayer2D = $"../../ExplosionAudioPlayer"

const Utils = preload("res://Scripts/Utils/utils.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_asteroids(count, Utils.AsteroidSize.BIG)

func get_random_position_from_screen_rect() -> Vector2:
	var rect = get_viewport().get_visible_rect()
	var camera = get_viewport().get_camera_2d()
	var zoom = camera.zoom
	var camera_position = camera.position
	var size = rect.size / zoom
	
	var bounds = {
		top = (camera_position.y - size.y) / 2,
		bottom = (camera_position.y + size.y) / 2,
		right = (camera_position.x + size.x) / 2,
		left = (camera_position.x - size.x) / 2,
	}
	
	var x = randi_range(bounds.left, bounds.right)
	var y = randi_range(bounds.top, bounds.bottom)
	
	return Vector2(x, y)

func spawn_asteroid(size: Utils.AsteroidSize, position: Vector2):
	var asteroid = asteroid_scene.instantiate() as Asteroid
	get_tree().root.add_child.call_deferred(asteroid)
	
	asteroid.global_position = position
	asteroid.size=size
	
	asteroid.on_asteroid_destroyed.connect(asteroid_destroyed)
	
func spawn_asteroids(number: int, size: int, position: Vector2 = Vector2.ZERO):
	var count = 0
	var start_pos:Vector2 = Vector2.ZERO

	while count < number:
		start_pos = get_random_position_from_screen_rect() if position == Vector2.ZERO else position
		
		spawn_asteroid(size, start_pos)
		count += 1
			
func asteroid_destroyed(size: int, position: Vector2):
	explosion_audio_player.play()
	
	if(size < 2):
		spawn_asteroids(2, size, position)
	
