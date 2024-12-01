extends Bullet

class_name BulletPlayer

const Utils = preload("res://Scripts/Utils/utils.gd")

@onready var score_manager: ScoreManager = $"/root/main/Managers/ScoreManager"

func _on_area_entered(area: Area2D) -> void:
	if area is Asteroid:
		if(area.size == Utils.AsteroidSize.BIG):
			score_manager.increase(20)
			
		if(area.size == Utils.AsteroidSize.MEDIUM):
			score_manager.increase(10)
			
	elif area is Ufo:
		score_manager.increase(50)

	else:
		print(area.get_class());
