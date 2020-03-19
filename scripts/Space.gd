extends "res://scripts/WorldSpace/WorldSpace.gd"


onready var character = $Character
onready var corvette = $Corvette
onready var simple_rocket = $SimpleRocket
onready var pequod = $Pequod
onready var station = $Station
onready var planet8 = $SphereOfInfluence/Planet8
onready var sphere_of_influence = $SphereOfInfluence

var asteroid_scene = preload("res://objects/ThingsInSpace/Asteroid.tscn")
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
		
func spawn_rigid_body_2d(object_scene:PackedScene, object_position:Vector2, object_rotation:float, object_velocity:Vector2):
	var instance = object_scene.instance()
	add_child(instance)
	if instance.has_method("get_group_name"):
		instance.add_to_group(instance.get_group_name())
	instance.self_scene = object_scene
	instance.set_position(object_position)
	instance.set_rotation(object_rotation)
	instance.set_axis_velocity(object_velocity)
	if object_scene == asteroid_scene:
		asteroid_counter += 1

func put_in_orbit(object_node:Node2D):
	var packed_scene = object_node.self_scene
	var node_instance = packed_scene.instance()
	var node_sprite = node_instance.get_node("Sprite")
	sphere_of_influence.spawn_orbiting_sprite(packed_scene, node_sprite, object_node.position)
	
