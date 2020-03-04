extends Node2D

onready var camera = $ViewportContainer/Viewport/Camera2D
onready var viewport = $ViewportContainer/Viewport
var target = null

func _process(delta):
	if target != null:
		camera.position = target.position

func set_world(world):
	viewport.world_2d = world

func set_target(new_target):
	if new_target.position != null:
		target = new_target
