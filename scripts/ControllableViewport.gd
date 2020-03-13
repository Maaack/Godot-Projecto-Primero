extends Control


const VIEW_TYPE_TRACKING = 0
const VIEW_TYPE_FREE = 1
const ZOOM_RATIO = 0.8
const ZOOM_IN_MAX = 6
const ZOOM_OUT_MAX = 22

export var click_range = 32
onready var camera_2d = $ViewportContainer/Viewport/Camera2D
onready var viewport = $ViewportContainer/Viewport
var view_centered_on = null
var view_zoom_level = 3
var view_scene_instance = null

func _physics_process(_delta):
	if view_centered_on != null and is_instance_valid(view_centered_on):
		camera_2d.set_position(view_centered_on.get_position())
		camera_2d.set_rotation(view_centered_on.get_rotation())

func set_scene_instance(scene_instance):
	if view_scene_instance != null:
		view_scene_instance.queue_free()
		if not is_instance_valid(view_scene_instance):
			view_scene_instance = null
	viewport.add_child(scene_instance)
	view_scene_instance = scene_instance
	return viewport.get_world_2d()

func set_world(world):
	viewport.set_world_2d(world)
	
func set_centered_on(target):
	if target.position != null:
		view_centered_on = target
		var zoom_ratio = get_zoom_ratio()
		camera_2d.set_zoom(Vector2(zoom_ratio, zoom_ratio))

func get_zoom_ratio():
	return pow(ZOOM_RATIO, view_zoom_level)

func get_scene_position(viewport_position:Vector2):
	var position_from_center = viewport_position - get_parent_area_size()/2
	position_from_center = position_from_center.rotated(view_centered_on.get_rotation())
	return (position_from_center * get_zoom_ratio()) + view_centered_on.get_position()

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_LEFT:
				var scene_click_position = get_scene_position(get_local_mouse_position())
				var click_range_total = pow(click_range,2) * get_zoom_ratio()
				for scene_node in view_scene_instance.get_children():
					if is_instance_valid(scene_node) and scene_node.has_method("get_position"):
						var scene_node_position = scene_node.get_position()
						if (scene_node_position - scene_click_position).length_squared() < click_range_total:
							view_centered_on.command_ship(scene_node)
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
