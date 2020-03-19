extends Node2D


onready var world_space = get_world_space()

func get_world_space():
	return get_parent().get_world_space()

func get_position_in_world_space():
	return get_position().rotated(get_parent().get_rotation()) + get_parent().get_position_in_world_space()
	
func get_rotation_in_world_space():
	return get_rotation() + get_parent().get_rotation_in_world_space()
	
func get_position_in_ancestor(node:Node2D):
	if node == self:
		return Vector2(0.0, 0.0)
	elif get_parent().has_method("get_position_in_ancestor"):
		return get_parent().get_position_in_ancestor(node) + get_position()
	return Vector2(0.0, 0.0)
	
func get_rotation_in_ancestor(node:Node2D):
	if node == self:
		return 0.0
	elif get_parent().has_method("get_rotation_in_ancestor"):
		return get_parent().get_rotation_in_ancestor(node) + get_rotation()
	return 0.0

func get_angle_to_target(node:Node2D):
	return get_angle_to(node.position)
