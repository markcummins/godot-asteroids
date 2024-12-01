extends Node

class_name PowerUpManager

signal updated_power_up

var active_power_up: int = -1

func set_active_power_up(pu: int):
	active_power_up = pu
	updated_power_up.emit(active_power_up)
