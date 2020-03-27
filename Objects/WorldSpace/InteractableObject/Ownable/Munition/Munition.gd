extends "res://Objects/WorldSpace/InteractableObject/RigidBody2D.gd"

const BASE_ORIENTATION = PI/2
export(float) var self_destruct_timeout = 20.0

var time_since_spawn = 0

func _process(delta):
	time_since_spawn += delta
	if time_since_spawn > self_destruct_timeout:
		queue_free()

func set_self_destruct_timeout(value:float):
	self_destruct_timeout = value

func _on_Bullet_body_entered(body):
	if body.has_method("impact") and last_linear_velocity != null:
		var relative_velocity = last_linear_velocity - body.get_linear_velocity()
		body.impact(relative_velocity, mass, legal_owner)
