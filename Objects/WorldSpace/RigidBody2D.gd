extends RigidBody2D


onready var world_space = get_world_space()
var physical_unit setget set_physical_unit, get_physical_unit

func set_physical_unit(value:PhysicalUnit):
	if value == null:
		return
	physical_unit = value.duplicate()
	position = physical_unit.position
	rotation = physical_unit.rotation
	linear_velocity = physical_unit.linear_velocity
	angular_velocity = physical_unit.angular_velocity

func get_physical_unit():
	if physical_unit == null:
		return
	physical_unit.position = position
	physical_unit.rotation = rotation
	physical_unit.linear_velocity = linear_velocity
	physical_unit.angular_velocity = angular_velocity
	return physical_unit

func get_world_space():
	var parent = get_parent()
	if parent != null and parent.has_method("get_world_space"):
		return get_parent().get_world_space()
	return self

func get_position_in_world_space():
	return get_position_in_ancestor(world_space)

func get_rotation_in_world_space():
	return get_rotation_in_ancestor(world_space)

func get_position_in_ancestor(node:Node2D):
	if node == self:
		return Vector2(0.0, 0.0)
	var parent = get_parent()
	if parent != null and parent.has_method("get_position_in_ancestor"):
		var total_rotation = parent.get_rotation_in_ancestor(node)
		var total_position = position.rotated(total_rotation)
		return parent.get_position_in_ancestor(node) + total_position
	return Vector2(0.0, 0.0)

func get_rotation_in_ancestor(node:Node2D):
	if node == self:
		return 0.0
	var parent = get_parent()
	if parent != null and parent.has_method("get_rotation_in_ancestor"):
		return parent.get_rotation_in_ancestor(node) + rotation
	return 0.0

func get_angle_to_target(node:Node2D):
	return get_angle_to(node.position)
