extends "res://scripts/BasicTarget.gd"


func remove_self():
	get_world_space().asteroid_space.asteroid_counter -= 1
	queue_free()
	
