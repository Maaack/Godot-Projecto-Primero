extends Node2D


func get_world_space():
	return get_parent().get_world_space()

func get_position_in_world_space():
	return get_position().rotated(get_rotation_in_world_space()) + get_parent().get_position_in_world_space()
	
func get_rotation_in_world_space():
	return get_rotation() + get_parent().get_rotation_in_world_space()
	
