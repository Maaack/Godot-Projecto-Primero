extends "res://scripts/BasicTarget.gd"

var self_destruct_timeout = 5.0

func _process(delta):
	if time_since_spawn > self_destruct_timeout:
		remove_self()


func _on_Bullet_body_shape_entered(body_id, body, body_shape, local_shape):
	if body.has_method("impact"):
		var relative_velocity = last_linear_velocity - body.get_linear_velocity()
		body.impact(relative_velocity, mass)
