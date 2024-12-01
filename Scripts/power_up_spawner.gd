extends Node

@export var power_up_scene: PackedScene

@onready var timer = $Timer

func _ready():
	timer.timeout.connect(spawn_power_up)

func spawn_power_up():
	var power_up = power_up_scene.instantiate() as PowerUp
	get_tree().root.add_child.call_deferred(power_up)
	
	var position = get_random_position_from_screen_rect()
	power_up.global_position = position
	
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
	
