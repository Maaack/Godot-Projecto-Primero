extends Node2D

const SCALE_MOD = 8.0

onready var viewport = $ViewportContainer/Viewport
onready var camera_2d = $ViewportContainer/Viewport/Camera2D
onready var pointing_circle_sprite = $PointingCircleSprite
onready var circle_sprite = $CircleSprite

var view_centered_on = null
var is_pointing = true setget set_is_pointing, get_is_pointing

func set_is_pointing(flag):
	is_pointing = bool(flag)
	if is_pointing:
		pointing_circle_sprite.show()
		circle_sprite.hide()
	else:
		circle_sprite.show()
		pointing_circle_sprite.hide()

func get_is_pointing():
	return is_pointing

func _physics_process(_delta):
	if view_centered_on != null and is_instance_valid(view_centered_on):
		camera_2d.set_position(view_centered_on.get_position())
		camera_2d.set_rotation(view_centered_on.get_rotation())

func get_zoom():
	var final_zoom = Vector2(1.0, 1.0)
	if view_centered_on.camera_scale != null:
		final_zoom *= view_centered_on.camera_scale
	return final_zoom * SCALE_MOD

func set_centered_on(target:Node2D):
	if target.get_position() != null:
		view_centered_on = target
		viewport.set_world_2d(target.get_world_2d())
		camera_2d.set_zoom(get_zoom())

func set_pointing_direction(rotation):
	pointing_circle_sprite.set_rotation(rotation)

func set_color(color):
	pointing_circle_sprite.set_modulate(color)
	circle_sprite.set_modulate(color)
