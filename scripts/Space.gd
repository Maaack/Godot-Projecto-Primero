extends "res://scripts/WorldSpace/WorldSpace.gd"


onready var character = $Character
onready var corvette = $Corvette
onready var simple_rocket = $SimpleRocket
onready var pequod = $Pequod
onready var station = $Station
onready var planet8 = $AsteroidSpace/Planet8
onready var space_whale = $SpaceWhale
onready var asteroid_space = $AsteroidSpace

onready var set_orbits = [
	corvette,
	simple_rocket,
	pequod,
	station,
]

func _ready():
	var asteroid_space_position = asteroid_space.get_position_in_world_space()
	for set_orbit_node in set_orbits:
		var relative_position = set_orbit_node.get_position_in_world_space() - asteroid_space_position
		var new_velocity = asteroid_space.get_orbital_velocity(relative_position)
		set_orbit_node.set_axis_velocity(new_velocity)
