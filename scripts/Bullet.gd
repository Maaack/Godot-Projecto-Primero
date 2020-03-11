extends "res://scripts/BasicTarget.gd"


const BASE_ORIENTATION = PI/2
export(float) var self_destruct_timeout = 20.0
var physical_owner = null setget set_physical_owner, get_physical_owner

func _process(_delta):
	if time_since_spawn > self_destruct_timeout:
		remove_self()

func set_self_destruct_timeout(value:float):
	self_destruct_timeout = value

func set_physical_owner(object:Node2D):
	if is_instance_valid(object):
		physical_owner = object
		
func get_physical_owner():
	return physical_owner
		
func _on_Bullet_body_shape_entered(_body_id, body, _body_shape, _local_shape):
	if body.has_method("impact") and last_linear_velocity != null:
		var relative_velocity = last_linear_velocity - body.get_linear_velocity()
		body.impact(relative_velocity, mass, physical_owner)
