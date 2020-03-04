extends ViewportContainer


const VIEW_TYPE_TRACKING = 0
const VIEW_TYPE_FREE = 1
const ZOOM_RATIO = 0.8
const ZOOM_IN_MAX = 6
const ZOOM_OUT_MAX = 15

onready var camera = $Viewport/Camera2D
onready var viewport = $Viewport
var camera_target = null
var zoom_level = 0

func _process(delta):
	if camera_target != null:
		camera.position = camera_target.position
		camera.rotation = camera_target.rotation

func set_world(world):
	viewport.world_2d = world
	
func set_camera_target(new_target):
	if new_target.position != null:
		camera_target = new_target

func get_zoom_ratio():
	return pow(ZOOM_RATIO, zoom_level)

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				zoom_level += 1
			if event.button_index == BUTTON_WHEEL_DOWN:
				zoom_level -= 1
			if zoom_level >= ZOOM_IN_MAX:
				zoom_level = ZOOM_IN_MAX
			elif zoom_level <= -(ZOOM_OUT_MAX):
				zoom_level = -(ZOOM_OUT_MAX)
			var zoom_ratio = get_zoom_ratio()
			camera.zoom = Vector2(zoom_ratio, zoom_ratio)
