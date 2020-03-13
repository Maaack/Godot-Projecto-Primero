extends Control

onready var viewport_and_overlay = $ViewportAndOverlay
onready var asteroid_counter = $Asteroids/Value
onready var money_counter = $Money/Value

var space_instance = preload("res://objects/Space.tscn").instance() 

# Called when the node enters the scene tree for the first time.
func _ready():
	viewport_and_overlay.set_scene_instance(space_instance)
	viewport_and_overlay.add_target(space_instance.simple_rocket)
	viewport_and_overlay.add_target(space_instance.pequod)
	viewport_and_overlay.add_target(space_instance.corvette)
	viewport_and_overlay.add_target(space_instance.station)
	viewport_and_overlay.add_target(space_instance.planet8)
	viewport_and_overlay.add_target(space_instance.space_whale)
	viewport_and_overlay.set_centered_on(space_instance.character)

func _process(_delta):
	asteroid_counter.set_text(str(space_instance.asteroid_counter))
	money_counter.set_text(str(space_instance.character.money))
