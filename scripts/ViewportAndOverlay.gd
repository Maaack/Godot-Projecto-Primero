extends Control


onready var viewport = $ControllableViewport
onready var centered_container = $Overlay/MarginContainer/CenterContainer
onready var centered_overlay = $Overlay/MarginContainer/CenterContainer/CenteredOverlay

var circular_viewport_scene = preload("res://objects/CircularViewport.tscn")
var tracker_tracer_scene = preload("res://objects/TracerTracker.tscn")

var view_world = null
var view_centered_on = null
var view_centered_on_position = null
var view_ship = null
var view_targets = []
var viewport_target_dict = {}
var tracer_tracker_target_dict = {}
var target_tracer_tracker_dict = {}
var target_color_index_dict = {}

export var view_min_zoom_scale_for_overlay = Vector2(1.5625, 1.5625)
export(Array, Color) var colors = [
	Color( 0.705882, 0.705882, 0.705882, 1 ),
	Color( 1, 0.5, 0.5, 1 ),
	Color( 1, 0.717647, 0.227451, 1 ),
	Color( 1, 0.952941, 0.239216, 1 ),
	Color( 0.396078, 1, 0.309804, 1 ),
	Color( 0.290196, 0.968627, 1, 1 ),
	Color( 0.431373, 0.505882, 1, 1 ),
	Color( 0.607843, 0.356863, 0.733333, 1 )
]

func _physics_process(_delta):
	update_circular_viewports()
	update_tracer_trackers()

func set_world(world):
	view_world = world
	viewport.set_world(world)
	
func set_centered_on(target):
	if target.get_position() != null:
		view_centered_on = target
		view_ship = target
		viewport.set_centered_on(target)

func set_centered_on_position(position):
		view_centered_on_position = position

func add_target(target):
	var instance = circular_viewport_scene.instance()
	centered_overlay.add_child(instance)
	instance.set_world(view_world)
	instance.set_centered_on(target)
	var color_index = view_targets.size() % colors.size()
	target_color_index_dict[target] = color_index
	instance.set_color(colors[color_index])
	viewport_target_dict[instance] = target
	view_targets.append(target)
	return instance
	
func get_tracer_tracker(target):
	var instance = null
	if target_tracer_tracker_dict.has(target):
		return target_tracer_tracker_dict[target]
	reset_tracer_trackers()
	for tracer_tracker in tracer_tracker_target_dict:
		var current_target = tracer_tracker_target_dict[tracer_tracker]
		if current_target == null:
			instance = tracer_tracker
			break
	if instance == null:
		instance = tracker_tracer_scene.instance()
		centered_overlay.add_child(instance)
		var color_index = tracer_tracker_target_dict.size() % colors.size()
		instance.set_color(colors[color_index])
	instance.show()
	tracer_tracker_target_dict[instance] = target
	target_tracer_tracker_dict[target] = instance
	return instance

func get_screen_position(object:Node2D):
	var relative_position = object.get_position() - view_centered_on.get_position()
	var rotated_position = relative_position.rotated(-view_centered_on.get_rotation())
	return rotated_position * (1/viewport.get_zoom_ratio())
	
func should_show_circular_viewport(circular_viewport, relative_position):
	if not is_position_on_screen(relative_position):
		return true
	return (circular_viewport.get_zoom() <= viewport.camera_2d.get_zoom())
	
func should_show_overlay_elements():
	return (viewport.camera_2d.get_zoom() > view_min_zoom_scale_for_overlay)
	
func is_position_on_screen(position:Vector2):
	var screen_size = centered_container.get_size()
	var screen_x = screen_size.x/2
	var screen_y = screen_size.y/2
	if abs(position.x) > screen_x:
		return false
	if abs(position.y) > screen_y:
		return false
	return true

func get_position_clamped_to_screen(position:Vector2):
	var screen_size = centered_container.get_size()
	var screen_x = screen_size.x/2
	var screen_y = screen_size.y/2
	var ratio_x = 1.0
	var ratio_y = 1.0
	var new_position = Vector2(position)
	if abs(new_position.x) > screen_x:
		ratio_x = screen_x / abs(new_position.x) 
	if abs(new_position.y) > screen_y:
		ratio_y = screen_y / abs(new_position.y)
	var ratio = min(ratio_x, ratio_y)
	return new_position * ratio
	
func update_circular_viewports():
	for circular_viewport in viewport_target_dict:
		var target = viewport_target_dict[circular_viewport]
		if target == null or !is_instance_valid(target):
			viewport_target_dict[circular_viewport] = null
			circular_viewport.hide()
			continue
		var relative_screen_position = get_screen_position(target)
		var final_screen_position = get_position_clamped_to_screen(relative_screen_position)
		if should_show_circular_viewport(circular_viewport, relative_screen_position):
			circular_viewport.show()
			circular_viewport.set_position(final_screen_position)
			if is_position_on_screen(relative_screen_position):
				circular_viewport.set_is_pointing(false)
			else:
				circular_viewport.set_pointing_direction(view_centered_on.get_angle_to_target(target))
				circular_viewport.set_is_pointing(true)
		else:
			circular_viewport.hide()
	
func reset_tracer_trackers():
	for tracer_tracker in tracer_tracker_target_dict:
		var target = tracer_tracker_target_dict[tracer_tracker]
		if not is_instance_valid(target):
			target_tracer_tracker_dict.erase(target)
			tracer_tracker_target_dict[tracer_tracker] = null
			tracer_tracker.hide()
			
func hide_all_tracer_trackers():
	for tracer_tracker in tracer_tracker_target_dict:
		tracer_tracker.hide()

func update_tracer_trackers():
	if not should_show_overlay_elements() \
	or not is_instance_valid(view_ship) \
	or not view_ship.has_method("get_tracer_list"):
		hide_all_tracer_trackers()
		return
	reset_tracer_trackers()
	var tracer_list = view_ship.get_tracer_list()
	for tracer in tracer_list:
		var tracer_tracker = get_tracer_tracker(tracer)
		tracer_tracker.set_position(get_screen_position(tracer))
