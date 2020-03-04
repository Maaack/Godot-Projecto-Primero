extends Control


onready var viewport = $ControllableViewport
onready var centered_container = $Overlay/MarginContainer/CenterContainer
onready var centered_overlay = $Overlay/MarginContainer/CenterContainer/CenteredOverlay

var circular_viewport_scene = preload("res://objects/CircularViewport.tscn")

var view_world = null
var view_centered_on = null
var view_centered_on_position = null
var view_targets = {}
var colors = {
	0: Color(1.0,1.0,1.0,1),
	1: Color(1.0,0.5,0.5,1),
	2: Color(0.5,1,0.5,1),
	3: Color(0.5,0.5,1,1)
}

func set_world(world):
	view_world = world
	viewport.set_world(world)
	
func set_centered_on(target):
	if target.get_position() != null:
		view_centered_on = target
		viewport.set_centered_on(target)

func set_centered_on_position(position):
		view_centered_on_position = position

func add_target(target):
	var instance = circular_viewport_scene.instance()
	centered_overlay.add_child(instance)
	instance.set_world(view_world)
	instance.set_centered_on(target)
	var color_index = len(view_targets) % len(colors)
	instance.set_color(colors[color_index])
	view_targets[target] = instance

func get_screen_position(object:Node2D):
	var relative_position = object.get_position() - view_centered_on.get_position()
	var rotated_position = relative_position.rotated(-view_centered_on.get_rotation())
	return rotated_position * (1/viewport.get_zoom_ratio())
	
func should_show_circular_viewport(circular_viewport, relative_position):
	if not is_position_on_screen(relative_position):
		return true
	return (circular_viewport.get_zoom() <= viewport.camera_2d.get_zoom())
	
func is_position_on_screen(position:Vector2):
	var screen_size = centered_container.get_size()
	if position.x < -(screen_size.x/2):
		return false
	if position.x > screen_size.x/2:
		return false
	if position.y < -(screen_size.y/2):
		return false
	if position.y > screen_size.y/2:
		return false
	return true

func clamped_position_to_screen(position:Vector2):
	var screen_size = centered_container.get_size()
	var new_position = Vector2(position)
	if new_position.x < -(screen_size.x/2):
		new_position.x = -(screen_size.x/2)
	if new_position.x > screen_size.x/2:
		new_position.x = screen_size.x/2
	if new_position.y < -(screen_size.y/2):
		new_position.y = -(screen_size.y/2)
	if new_position.y > screen_size.y/2:
		new_position.y = screen_size.y/2
	return new_position
	
func _physics_process(delta):
	for target in view_targets:
		var circular_viewport = view_targets[target]
		var relative_screen_position = get_screen_position(target)
		var final_screen_position = clamped_position_to_screen(relative_screen_position)
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
#	arrow_2_hud.rotation = character.get_angle_to_target(planet8)
