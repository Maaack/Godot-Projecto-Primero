extends "res://Objects/ThingsInSpace/BasicTarget/Destructable/Destructable.gd"


const BASE_ORIENTATION = PI/2
export(float) var self_destruct_timeout = 20.0

func _process(_delta):
	if time_since_spawn > self_destruct_timeout:
		destroy_self()

func set_self_destruct_timeout(value:float):
	self_destruct_timeout = value
		
func _on_Bullet_body_shape_entered(_body_id, body, _body_shape, _local_shape):
	if body.has_method("impact") and last_linear_velocity != null:
		var relative_velocity = last_linear_velocity - body.get_linear_velocity()
		body.impact(relative_velocity, mass, legal_owner)
