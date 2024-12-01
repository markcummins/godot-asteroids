extends Node2D

@export var bullet_scene: PackedScene

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed('shoot'):
		var bullet = bullet_scene.instantiate() as BulletPlayer
		get_tree().root.add_child(bullet)
		
		var shot_direction = Vector2(0,1).rotated(get_parent().rotation)
		bullet.position = global_position
		bullet.direction = shot_direction
		
	if Input.is_action_just_pressed('superpower'):
		var loops = 5
		
		for l in range(loops):
			await get_tree().create_timer(0.35).timeout 
			bullet_spread()

func bullet_spread():
	var spread = 24

	for i in range(spread):
		var bullet = bullet_scene.instantiate() as BulletPlayer
		bullet.bullet_speed = 300
		
		get_tree().root.add_child(bullet)
		var shot_direction =  Vector2.RIGHT.rotated(deg_to_rad((i*(360/spread))+90))
		
		bullet.position = global_position
		bullet.direction = shot_direction
		
		await get_tree().create_timer(0.025).timeout 
