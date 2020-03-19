extends "res://scripts/BasicTarget.gd"


func destroy_self():
	if can_destroy():
		get_world_space().asteroid_space.asteroid_counter -= 1
		.destroy_self()
