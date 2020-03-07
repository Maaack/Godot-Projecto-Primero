extends "res://scripts/BasicTarget.gd"

export(float) var self_destruct_timeout = 20.0
var legal_owner = null setget set_legal_owner, get_legal_owner

func _process(_delta):
	if time_since_spawn > self_destruct_timeout:
		remove_self()

func set_self_destruct_timeout(value:float):
	self_destruct_timeout = value

func set_legal_owner(object:Node2D):
	if is_instance_valid(object):
		legal_owner = object
		
func get_legal_owner():
	return legal_owner
		
func _on_Bullet_body_shape_entered(_body_id, body, _body_shape, _local_shape):
	if body.has_method("impact") and last_linear_velocity != null:
		var relative_velocity = last_linear_velocity - body.get_linear_velocity()
		body.impact(relative_velocity, mass, legal_owner)
