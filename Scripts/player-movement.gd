extends CharacterBody2D

class_name Player

signal on_player_died

@export var max_speed=10
@export var rotation_speed=5
@export var velocity_damping_factor=1.5
@export var linear_velocity=500

@onready var sprite: Sprite2D = $Sprite2D

@onready var blinking_timer: Timer = $BlinkingTimer
@onready var invincibility_timer: Timer = $InvincibilityTimer

@onready var engine: Sprite2D = $Engine

@onready var audio_engine: AudioStreamPlayer2D = $AudioEngine
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var explosion_particles: CPUParticles2D = $ExplosionParticles

@onready var explosion_audio_player: AudioStreamPlayer2D = $"../ExplosionAudioPlayer"

var input_vector: Vector2

var rotation_direction: int

var is_invincible: bool = false

func _ready():
	blinking_timer.timeout.connect(toggle_visibility)
	invincibility_timer.timeout.connect(stop_invincibility)
	
func toggle_visibility():
	sprite.visible = !sprite.visible
	
func stop_invincibility():
	is_invincible = false
	sprite.visible = true
	
	blinking_timer.stop()
	invincibility_timer.stop()
	
func start_invincibility():
	is_invincible = true
	blinking_timer.start()
	invincibility_timer.start()
	
func _process(delta):
	input_vector.x = Input.get_action_strength('rotate_left') - Input.get_action_strength('rotate_right')
	input_vector.y = Input.get_action_strength('thrust')
	
	if Input.is_action_pressed('rotate_left'):
		rotation_direction=-1
	elif Input.is_action_pressed('rotate_right'):
		rotation_direction=1
	else:
		rotation_direction=0
		
	if input_vector.y != 0:
		if !audio_engine.playing:
			audio_engine.play()
			
		animation_player.play("engine-animation")
	else:
		if audio_engine.playing:
			audio_engine.stop()
			
		animation_player.stop()
		engine.visible = false
		
func _physics_process(delta):
	rotation += rotation_direction * rotation_speed * delta

	if( input_vector.y > 0):
		accelerate_forward(delta)
	elif(input_vector.y == 0 && velocity != Vector2.ZERO):
		slow_down_and_stop(delta)
		
	move_and_collide(velocity * delta)

func accelerate_forward(delta: float):
	velocity += (input_vector * linear_velocity * delta).rotated(rotation)
	velocity.limit_length(max_speed)
	
func slow_down_and_stop(delta: float):
	velocity = lerp(velocity, Vector2.ZERO, velocity_damping_factor * delta)
	
	# Stop
	if velocity.y >= -0.1 && velocity.y <= 0.1:
		velocity.y = 0 

func emit_explosion():
	explosion_particles.emitting = true
	explosion_particles.reparent(get_tree().root)
	
func on_destroy():
	emit_explosion()
	explosion_audio_player.play()
	
	on_player_died.emit()
	queue_free()
