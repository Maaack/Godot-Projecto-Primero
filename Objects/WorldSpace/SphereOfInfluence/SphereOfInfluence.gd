extends "res://Objects/WorldSpace/Node2D.gd"


onready var gravity_space = $Area2D
onready var gravity_space_collider = $Area2D/CollisionShape2D
onready var planet = $Planet8
onready var planet_collider = $Planet8/CollisionShape2D

signal player_left_area

export var sphere_size_mod = 1.5
export var asteroid_spawn_distance_from_surface = 15000.0
enum OrbitDirectionSetting{CLOCKWISE, COUNTER_CLOCKWISE, EITHER}
export(OrbitDirectionSetting) var orbit_direction
export var vector_scale_mod = 1.0
export(Array, Resource) var rings
export(NodePath) var player_character_path

var player_character
var orbiting_node_scene = preload("res://Objects/WorldSpace/OrbitingNode2D/OrbitingNode2D.tscn")

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

func spawn_orbiting_sprite(physical_unit:PackedScenesUnit):
	var instance = orbiting_node_scene.instance()
	add_child(instance)
	instance.gravity_force = gravity_space.get_gravity()
	instance.orbit_direction = orbit_direction
	instance.physical_unit = physical_unit
	instance.player_character = player_character
	return instance

func spawn_orbiting_rings():
	var min_spawn_radius = get_min_spawn_radius()
	for ring in rings:
		if ring is PlanetaryRing:
			for physical_quantity in ring.physical_quantities:
				for _i in range(physical_quantity.quantity):
					var physical_unit = physical_quantity.get_physical_unit()
					var random_orbit_radius = rand_range(ring.inner_radius, ring.outer_radius)
					random_orbit_radius += min_spawn_radius
					physical_unit.position = get_random_vector() * random_orbit_radius
					spawn_orbiting_sprite(physical_unit)

func _ready():
	if player_character_path != null:
		player_character = get_node(player_character_path)
	spawn_orbiting_rings()
	gravity_space_collider.shape.radius *= sphere_size_mod

func _on_Area2D_body_exited(body):
	if body.has_method("get_commander"):
		var commander = body.get_commander()
		if commander == player_character:
			emit_signal("player_left_area")
