extends Control

onready var world_viewport = $WorldViewportContainer/WorldViewport
onready var space = $WorldViewportContainer/WorldViewport/Space
onready var rotation_hud = $Rotation/Value
onready var angle_hud = $AngleTo/Value
onready var viewport_and_overlay = $ViewportAndOverlay

# Called when the node enters the scene tree for the first time.
func _ready():
	var world = world_viewport.get_world_2d()
	viewport_and_overlay.set_world(world)
	viewport_and_overlay.add_target(space.character)
	viewport_and_overlay.add_target(space.station)
	viewport_and_overlay.add_target(space.planet8)
	viewport_and_overlay.add_target(space.space_whale)
	viewport_and_overlay.set_centered_on(space.character)
