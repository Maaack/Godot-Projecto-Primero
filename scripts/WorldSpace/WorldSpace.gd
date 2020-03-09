extends "res://scripts/WorldSpace/Node2D.gd"

export var world_space_size_base = Vector2(4096.0, 4096.0)
export var world_space_size_mod = Vector2(40.0, 40.0)
export var is_zero_centered = true

# func overrides
func get_world_space():
	return self
	
func get_position_in_world_space():
	return Vector2(0.0, 0.0)

func get_rotation_in_world_space():
	return 0.0

func get_world_space_size():
	return world_space_size_base * world_space_size_mod
	
func get_top_left_corner():
	if is_zero_centered:
		var world_space_size = get_world_space_size()
		return -(world_space_size / 2)
	else: 
		return Vector2(0.0, 0.0)

func get_bottom_right_corner():
	var world_space_size = get_world_space_size()
	if is_zero_centered:
		return world_space_size / 2
	else: 
		return world_space_size
	

func get_random_position_in_world_space():
	var top_left_corner = get_top_left_corner()
	var bottom_right_corner = get_bottom_right_corner()
	var start_position_x = rand_range(top_left_corner.x, bottom_right_corner.x)
	var start_position_y = rand_range(top_left_corner.y, bottom_right_corner.y)
	return Vector2(start_position_x, start_position_y)


func is_position_in_world_space(a_position:Vector2):
	var top_left_corner = get_top_left_corner()
	var bottom_right_corner = get_bottom_right_corner()
	if a_position.x > bottom_right_corner.x:
		return false
	if a_position.x < top_left_corner.x:
		return false
	if a_position.y > bottom_right_corner.y:
		return false
	if a_position.y < top_left_corner.y:
		return false
	return true

func remove_object_path(parent_node, object_path):
	parent_node.get_node(object_path).queue_free()
	
