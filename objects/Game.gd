extends Control

onready var world_viewport = $WorldViewportContainer/WorldViewport
onready var space = $WorldViewportContainer/WorldViewport/Space
onready var character = $WorldViewportContainer/WorldViewport/Space/Character
onready var station = $WorldViewportContainer/WorldViewport/Space/Station
onready var planet8 = $WorldViewportContainer/WorldViewport/Space/Planet8
onready var arrow_1_hud = $CenterContainer/Control/Arrow_1
onready var arrow_2_hud = $CenterContainer/Control/Arrow_2
onready var rotation_hud = $Rotation/Value
onready var angle_hud = $AngleTo/Value
onready var circular_viewport = $CenterContainer/Control/CircularViewport
onready var circular_viewport2 = $CenterContainer/Control/CircularViewport2
onready var viewport_and_overlay = $ViewportAndOverlay

# Called when the node enters the scene tree for the first time.
func _ready():
	var world = world_viewport.get_world_2d()
	viewport_and_overlay.set_world(world)
	viewport_and_overlay.add_target(space.character)
	viewport_and_overlay.add_target(space.station)
	viewport_and_overlay.add_target(space.planet8)
	viewport_and_overlay.set_centered_on(space.character)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#	var centered_on = space.character
#	rotation_hud.set_text(str(centered_on.rotation))
#
#	var screen_position = get_screen_position(station)
#	angle_hud.set_text(str(screen_position))
#	circular_viewport.position = screen_position
#	circular_viewport.set_direction(character.get_angle_to_target(station))
#	circular_viewport2.position = get_screen_position(planet8)
#	circular_viewport2.set_direction(character.get_angle_to_target(planet8))
##	arrow_2_hud.rotation = character.get_angle_to_target(planet8)
#
#func get_screen_position(object):
#	var centered_on = space.character
#	var relative_position = object.position - centered_on.position
#	var rotated_position = relative_position.rotated(-centered_on.rotation)
#	return rotated_position * (1/viewport_and_overlay.viewport.get_zoom_ratio())
