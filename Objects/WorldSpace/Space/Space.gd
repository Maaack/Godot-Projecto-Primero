extends "res://Objects/WorldSpace/WorldSpace.gd"


onready var character = $Character
onready var corvette = $Corvette
onready var simple_rocket = $SimpleRocket
onready var pequod = $Pequod
onready var station = $Station
onready var planet8 = $SphereOfInfluence/Planet8
onready var sphere_of_influence = $SphereOfInfluence

var asteroid_counter = 0

onready var ignore_orbit = [
	character,
	sphere_of_influence,
	$ParallaxBackground
]

func _ready():
	var sphere_of_influence_position = sphere_of_influence.get_position_in_world_space()
	for child in get_children():
		if ignore_orbit.has(child) or not child.has_method("set_axis_velocity"):
			continue
		var relative_position = child.get_position_in_world_space() - sphere_of_influence_position
		var new_velocity = sphere_of_influence.get_orbital_velocity(relative_position)
		child.set_axis_velocity(new_velocity)

func spawn_rigid_body_2d(physical_unit:PackedSceneUnit):
	if physical_unit == null:
		print("Error: Spawn rigid body called with null!")
		return
	var instance = physical_unit.packed_scene.instance()
	add_child(instance)
	instance.add_to_group(physical_unit.group_name)
	instance.physical_unit = physical_unit
	if physical_unit.group_name == 'ASTEROID':
		asteroid_counter += 1
	return instance

func put_in_orbit(resource:PhysicalUnit):
	sphere_of_influence.spawn_orbiting_sprite(resource)
	
