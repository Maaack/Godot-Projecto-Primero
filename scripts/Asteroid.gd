extends "res://scripts/BasicTarget.gd"


export var armor = 1.0

func remove_self():
	get_world_space().asteroid_counter -= 1
	queue_free()
	
