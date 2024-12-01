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
