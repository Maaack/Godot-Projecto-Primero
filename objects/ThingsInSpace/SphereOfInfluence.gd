extends "res://scripts/WorldSpace/Node2D.gd"


const ASTEROID_GROUP_NAME = "asteroids"

onready var gravity_space = $Area2D
onready var gravity_space_collider = $Area2D/CollisionShape2D
onready var planet = $Planet8
onready var planet_collider = $Planet8/CollisionShape2D

export var sphere_size_mod = 1.5
export var asteroid_spawn_distance_from_surface = 15000.0
enum OrbitDirectionSetting{CLOCKWISE, COUNTER_CLOCKWISE, EITHER}
export(OrbitDirectionSetting) var orbit_direction
export var vector_scale_mod = 1.0

var orbiting_node_scene = preload("res://objects/ThingsInSpace/OrbitingNode2D.tscn")
var asteroid_scene = preload("res://objects/ThingsInSpace/Asteroid.tscn")

export(Array, Resource) var rings

export(NodePath) var player_character_path
var player_character


func get_space_radius():
	return gravity_space_collider.shape.radius

func get_planet_radius():
	return planet_collider.shape.radius

func get_min_spawn_radius():
	return get_planet_radius() + asteroid_spawn_distance_from_surface

func get_random_vector():
	var random_rotation = rand_range(0, PI*2)
	return Vector2(1,0).rotated(random_rotation)

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
	return instance

func spawn_orbiting_rings():
	var min_spawn_radius = get_min_spawn_radius()
	var asteroid_instance = asteroid_scene.instance()
	var sprite = asteroid_instance.get_node("Sprite")
	for ring in rings:
		if ring is PlanetaryRing:
			for _i in range(ring.count):
				var random_orbit_radius = rand_range(ring.inner_radius, ring.outer_radius)
				random_orbit_radius += min_spawn_radius
				var random_position = get_random_vector() * random_orbit_radius
				var instance = spawn_orbiting_sprite(asteroid_scene, sprite, random_position)
				instance.sprite.modulate = ring.color

func _ready():
	if player_character_path != null:
		player_character = get_node(player_character_path)
	spawn_orbiting_rings()
	gravity_space_collider.shape.radius *= sphere_size_mod
