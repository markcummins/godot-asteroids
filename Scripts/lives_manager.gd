extends Node

class_name LivesManager

signal player_life_lost(lives_left: int)

const player_start_position = Vector2(0,0)

@export var lives = 3

const PLAYER_SCENE = preload("res://Scenes/player.tscn")
@onready var player: Player = $"../../Firefly" as Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_setup(player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func decrease_lives():
	lives -= 1
	player_life_lost.emit(lives)
	
	if lives != 0:
		player_reload()

func player_setup(player: Player):
	player.on_player_died.connect(decrease_lives)
	
func player_reload():
	var new_player = PLAYER_SCENE.instantiate() as Player
	player_setup(new_player)
	
	get_tree().root.get_node("main").add_child(new_player)
	new_player.global_position = player_start_position
	new_player.start_invincibility()
	
	
