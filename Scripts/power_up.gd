extends Node2D

class_name PowerUp

const PowerUpTypes = preload("res://Scripts/Utils/power-up-type.gd")

@onready var power_up_manager: PowerUpManager = $"/root/main/Managers/PowerUpManager"

@onready var type: int

func _ready() -> void:
	# randomize()

	var enum_size = len(PowerUpTypes.Type)
	type = PowerUpTypes.Type.values()[randi() % enum_size]

func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		power_up_manager.set_active_power_up(type)
		
	queue_free()
