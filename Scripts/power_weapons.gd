extends Node2D

@export var bullet_scene: PackedScene

const PowerUpTypes = preload("res://Scripts/Utils/power-up-type.gd")

@onready var power_up_manager: PowerUpManager = $"/root/main/Managers/PowerUpManager"

func _process(delta: float) -> void:
	if(power_up_manager.active_power_up == -1):
		return
		
	if Input.is_action_just_pressed('superpower'):
		var type = PowerUpTypes.Type
		
		if power_up_manager.active_power_up == type.BOMB:
			var loops = 3
			for l in range(loops):
				bullet_spread(1, 32, 0)
				await get_tree().create_timer(0.35).timeout 

		if power_up_manager.active_power_up == type.BLAST:
			var loops = 3
			for l in range(loops):
				bullet_spread(5, 24, 0.025)
				await get_tree().create_timer(0.25).timeout 
	
	
func bullet_spread(loops: int, spread: int, interval: float):
	power_up_manager.set_active_power_up(-1)
	
	for i in range(spread):
		var bullet = bullet_scene.instantiate() as BulletPlayer
		bullet.bullet_speed = 300
		
		get_tree().root.add_child(bullet)
		var shot_direction =  Vector2.RIGHT.rotated(deg_to_rad((i*(360/spread))+90))
		
		bullet.position = global_position
		bullet.direction = shot_direction
		
		if(interval > 0):
			await get_tree().create_timer(interval).timeout 
