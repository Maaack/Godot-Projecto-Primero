extends Control


const VIEW_TYPE_TRACKING = 0
const VIEW_TYPE_FREE = 1
const ZOOM_RATIO = 0.8
const ZOOM_IN_MAX = 6
const ZOOM_OUT_MAX = 22

onready var camera_2d = $ViewportContainer/Viewport/Camera2D
onready var viewport = $ViewportContainer/Viewport
var view_centered_on = null
var view_zoom_level = 3

func _physics_process(delta):
	if view_centered_on != null:
		camera_2d.set_position(view_centered_on.get_position())
		camera_2d.set_rotation(view_centered_on.get_rotation())

func set_world(world):
	viewport.set_world_2d(world)
	
func set_centered_on(target):
	if target.position != null:
		view_centered_on = target
		var zoom_ratio = get_zoom_ratio()
		camera_2d.set_zoom(Vector2(zoom_ratio, zoom_ratio))

func get_zoom_ratio():
	return pow(ZOOM_RATIO, view_zoom_level)

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				view_zoom_level += 1
			if event.button_index == BUTTON_WHEEL_DOWN:
				view_zoom_level -= 1
			if view_zoom_level >= ZOOM_IN_MAX:
				view_zoom_level = ZOOM_IN_MAX
			elif view_zoom_level <= -(ZOOM_OUT_MAX):
				view_zoom_level = -(ZOOM_OUT_MAX)
			var zoom_ratio = get_zoom_ratio()
			camera_2d.set_zoom(Vector2(zoom_ratio, zoom_ratio))
