extends "res://scripts/BasicTarget.gd"

var self_destruct_timeout = 3.0

func _process(delta):
	if time_since_spawn > self_destruct_timeout:
		remove_self()
