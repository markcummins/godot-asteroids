extends Node

class_name ScoreManager

signal score_updated(score: int)

@onready var score:int = 0
	
func increase(score_add: int):
	score = score + score_add
	score_updated.emit(score)
