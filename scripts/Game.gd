extends Control

onready var viewport_and_overlay = $ViewportAndOverlay

var space_scene = preload("res://Objects/Space.tscn")
var space_instance = null

# Called when the node enters the scene tree for the first time.
func _ready():
	start_game()

func start_game():
	space_instance = space_scene.instance()
	viewport_and_overlay.set_scene_instance(space_instance)
	return space_instance

func _on_ViewportAndOverlay_world_space_ready():
	viewport_and_overlay.add_target(space_instance.simple_rocket)
	viewport_and_overlay.add_target(space_instance.pequod)
	viewport_and_overlay.add_target(space_instance.corvette)
	viewport_and_overlay.add_target(space_instance.station)
	viewport_and_overlay.add_target(space_instance.planet8)
	viewport_and_overlay.set_centered_on(space_instance.character)

