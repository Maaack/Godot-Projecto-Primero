extends Control

onready var world_viewport = $WorldViewportContainer/WorldViewport
onready var space = $WorldViewportContainer/WorldViewport/Space
onready var viewport_and_overlay = $ViewportAndOverlay
onready var asteroid_counter = $Asteroids/Value

# Called when the node enters the scene tree for the first time.
func _ready():
	var world = world_viewport.get_world_2d()
	viewport_and_overlay.set_world(world)
	viewport_and_overlay.add_target(space.pequod)
	viewport_and_overlay.add_target(space.corvette)
	viewport_and_overlay.add_target(space.station)
	viewport_and_overlay.add_target(space.planet8)
	viewport_and_overlay.add_target(space.space_whale)
	viewport_and_overlay.set_centered_on(space.character)

func _process(delta):
	asteroid_counter.set_text(str(space.asteroid_counter))
