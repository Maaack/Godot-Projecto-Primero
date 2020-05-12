extends Control


onready var viewport_and_overlay = $ViewportAndOverlay
onready var instructions = $Instructions
onready var inspector = $RocketInspector

var space_scene = preload("res://Objects/WorldSpace/Space/Space.tscn")
var space_instance = null

func start_game():
	space_instance = space_scene.instance()
	viewport_and_overlay.set_scene_instance(space_instance)
	space_instance.connect("player_left_area", self, "_on_Space_player_left_area")
	instructions.show()
	return space_instance

func _on_ViewportAndOverlay_world_space_ready():
	viewport_and_overlay.add_target(space_instance.simple_rocket)
	viewport_and_overlay.add_target(space_instance.pequod)
	viewport_and_overlay.add_target(space_instance.station_alpha)
	viewport_and_overlay.add_target(space_instance.station_gamma)
	viewport_and_overlay.add_target(space_instance.planet8)
	viewport_and_overlay.set_centered_on(space_instance.character)
	inspector.show_ship(space_instance.simple_rocket)

func _on_StartMenu_start_game_triggered():
	start_game()

func _on_Space_player_left_area():
	$EndScreen.show()

func _input(event):
	if event.is_action_pressed("ui_inspect"):
		inspector.show_ship(space_instance.character.ship_node)
		if inspector.visible:
			inspector.hide()
		else:
			inspector.show()
	if event.is_action_pressed("ui_help"):
		if instructions.visible:
			instructions.hide()
		else:
			instructions.show()

