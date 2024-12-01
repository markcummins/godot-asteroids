extends Area2D

class_name Ufo

signal ufo_destroyed

@export var bullet_scene: PackedScene
@export var path: PathFollow2D

@onready var shooting_timer: Timer = $ShootingTimer
@onready var explosion_particles = $ExplosionParticles

@onready var ufo_shot_audio_player: AudioStreamPlayer2D = $UfoShotAudioPlayer

var speed = 50
var current_point_on_path = 0

func _ready():
	shooting_timer.timeout.connect(shoot)
	
func _process(delta):
	if path == null:
		return
		
	var progress = delta * speed;
	path.progress += progress
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func shoot():
	var bullet = bullet_scene.instantiate();
	bullet.set_collision_layer_value(2,0)
	bullet.set_collision_layer_value(5,1);
	
	get_tree().root.add_child(bullet)
	bullet.position = global_position
	bullet.direction = get_random_shot_direction()
	ufo_shot_audio_player.play()
	
func get_random_shot_direction():
	var node_y = get_global_transform().origin.y
	var screen_height = get_viewport().get_visible_rect().size.y
	
	var should_shoot_down = node_y <- screen_height / 2
	
	var angle = deg_to_rad(randf_range(45, 135)) if should_shoot_down else deg_to_rad(randf_range(225, 315))
	return Vector2(cos(angle), sin(angle))

func _on_body_entered(body: Node2D) -> void:
	if body is Player && !(body as Player).is_invincible:
		(body as Player).on_player_died.emit()
		body.queue_free()
		ufo_kaboom()

func _on_area_entered(area: Area2D) -> void:
	if area is Bullet:
		area.queue_free()
		ufo_kaboom()

func ufo_kaboom():
	ufo_destroyed.emit()
	queue_free()
	explosion_particles.emitting = true
	explosion_particles.reparent(get_tree().root)
