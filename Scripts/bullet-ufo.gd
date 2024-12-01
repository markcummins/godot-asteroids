extends Bullet

class_name BulletUfo

func _on_body_entered(body: Node2D) -> void:
	if body is Player && !(body as Player).is_invincible:
		body.on_destroy()
