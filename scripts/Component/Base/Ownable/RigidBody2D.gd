extends "res://scripts/WorldSpace/RigidBody2D.gd"

export(Resource) var physical_object setget set_physical_object, get_physical_object
var legal_owner = null setget set_legal_owner, get_legal_owner

func set_physical_object(value:PhysicalObject):
	if value != null:
		position = value.position
		rotation = value.rotation
		linear_velocity = value.linear_velocity
		angular_velocity = value.angular_velocity
		physical_object = value

func get_physical_object():
	if physical_object != null:
		physical_object.position = position
		physical_object.rotation = rotation
		physical_object.linear_velocity = linear_velocity
		physical_object.angular_velocity = angular_velocity
	return physical_object

func get_legal_owner():
	var parent = get_parent()
	if parent != null and parent.has_method("get_legal_owner"):
		var parent_legal_owner = get_parent().get_legal_owner()
		if parent_legal_owner != null:
			legal_owner = parent_legal_owner
	return legal_owner

func set_legal_owner(value):
	if is_instance_valid(value):
		legal_owner = value

func get_physical_owner():
	var parent = get_parent()
	if parent.has_method("get_physical_owner"):
		return get_parent().get_physical_owner()
	else:
		return self
