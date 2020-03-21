extends "res://scripts/WorldSpace/WorldSpace.gd"


onready var character = $Character
onready var corvette = $Corvette
onready var simple_rocket = $SimpleRocket
onready var pequod = $Pequod
onready var station = $Station
onready var planet8 = $SphereOfInfluence/Planet8
onready var sphere_of_influence = $SphereOfInfluence

var asteroid_counter = 0

onready var set_orbits = [
	corvette,
	simple_rocket,
	pequod,
	station,
]

func _ready():
	var sphere_of_influence_position = sphere_of_influence.get_position_in_world_space()
	for set_orbit_node in set_orbits:
		var relative_position = set_orbit_node.get_position_in_world_space() - sphere_of_influence_position
		var new_velocity = sphere_of_influence.get_orbital_velocity(relative_position)
		set_orbit_node.set_axis_velocity(new_velocity)
		
func spawn_rigid_body_2d(physical_object:PhysicalObject):
	var instance = physical_object.packed_scene.instance()
	add_child(instance)
	instance.add_to_group(physical_object.group_name)
	instance.physical_object = physical_object
	if physical_object.group_name == 'ASTEROID':
		asteroid_counter += 1

func put_in_orbit(resource:PhysicalObject):
	sphere_of_influence.spawn_orbiting_sprite(resource)
	
