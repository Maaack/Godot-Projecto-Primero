extends "res://scripts/WorldSpace/Node2D.gd"


const ASTEROID_GROUP_NAME = "asteroids"

onready var gravity_space = $Area2D
onready var gravity_space_collider = $Area2D/CollisionShape2D
onready var planet = $Planet8
onready var planet_collider = $Planet8/CollisionShape2D

export var asteroid_spawn_distance_from_surface = 15000.0
export var asteroid_spawn_distance_from_edge = 15000.0
export var orbiting_asteroid_max = 1000
enum OrbitDirectionSetting{CLOCKWISE, COUNTER_CLOCKWISE, EITHER}
export(OrbitDirectionSetting) var orbit_direction
export var vector_scale_mod = 1.0

var orbiting_node_scene = preload("res://objects/ThingsInSpace/OrbitingNode2D.tscn")
var asteroid_scene = preload("res://objects/ThingsInSpace/Asteroid.tscn")
var asteroid_texture = preload("res://assets/kenney_spaceshooterextension/PNG/Sprites X2/Meteors/spaceMeteors_004.png")

export(NodePath) var player_character_path
var player_character

func get_space_radius():
	return gravity_space_collider.shape.radius

func get_planet_radius():
	return planet_collider.shape.radius

func get_random_orbit_radius():
	var min_spawn_radius = get_planet_radius() + asteroid_spawn_distance_from_surface
	var max_spawn_radius = get_space_radius() - asteroid_spawn_distance_from_edge
	return rand_range(min_spawn_radius, max_spawn_radius)

func get_random_orbit_position():
	var random_rotation = rand_range(0, PI*2)
	var direction = Vector2(1,0).rotated(random_rotation)
	var random_radius = get_random_orbit_radius()

	return direction * random_radius

func get_random_orbit_position_in_world_space():
	return get_position_in_world_space() + get_random_orbit_position()

func get_orbital_velocity(start_position:Vector2):
	if orbit_direction == OrbitDirectionSetting.EITHER:
		var orbit_directions = [OrbitDirectionSetting.CLOCKWISE, OrbitDirectionSetting.COUNTER_CLOCKWISE]
		orbit_directions.shuffle()
		orbit_direction = orbit_directions.pop_front()
	var orbit_vector = null
	if orbit_direction == OrbitDirectionSetting.CLOCKWISE:
		orbit_vector = Vector2(0,1)
	elif orbit_direction == OrbitDirectionSetting.COUNTER_CLOCKWISE:
		orbit_vector = Vector2(0,-1)
	else:
		print('Error: Not a valid orbit direction!')
	orbit_vector = orbit_vector.rotated(get_angle_to(start_position))
	var gravity_force = gravity_space.get_gravity()
	var distance = get_position().distance_to(start_position)
	var vector_scale = sqrt(gravity_force*distance) * vector_scale_mod
	return orbit_vector * vector_scale

func spawn_orbiting_sprite(object_scene:PackedScene, object_sprite:Sprite, object_position:Vector2):
	var instance = orbiting_node_scene.instance()
	instance.orbit_direction = orbit_direction
	instance.orbit_position = object_position
	instance.orbit_gravity_force = gravity_space.get_gravity()
	instance.orbit_object_scene = object_scene
	instance.orbit_object_texture = object_sprite.texture
	instance.orbit_object_texture_scale = object_sprite.scale
	instance.player_character = player_character
	add_child(instance)

func _ready():
	if player_character_path != null:
		player_character = get_node(player_character_path)
	var asteroid_instance = asteroid_scene.instance()
	var sprite = asteroid_instance.get_node("Sprite")
	for i in range(orbiting_asteroid_max):
		spawn_orbiting_sprite(asteroid_scene, sprite, get_random_orbit_position())
