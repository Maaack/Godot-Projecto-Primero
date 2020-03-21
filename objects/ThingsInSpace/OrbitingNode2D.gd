extends "res://scripts/WorldSpace/Node2D.gd"


const LOAD_IN_DISTANCE = 10000.0

onready var node_2d = $Node2D
onready var sprite = $Node2D/Sprite

export(float) var gravity_force

export(Resource) var physical_object setget set_physical_object, get_physical_object

enum OrbitDirectionSetting{CLOCKWISE, COUNTER_CLOCKWISE}
export(OrbitDirectionSetting) var orbit_direction

var orbit_distance
var orbit_theta
var player_character


func set_physical_object(resource:PhysicalObject):
	set_orbit(resource)
	set_sprite(resource)
	physical_object = resource

func get_physical_object():
	physical_object.position = node_2d.position + get_position_in_world_space()
	physical_object.rotation = sprite.rotation + get_rotation_in_world_space()
	physical_object.linear_velocity = get_parent().get_orbital_velocity(node_2d.position)
	return physical_object

func get_orbit_direction_mod():
	if orbit_direction == OrbitDirectionSetting.CLOCKWISE:
		return 1
	elif orbit_direction == OrbitDirectionSetting.COUNTER_CLOCKWISE:
		return -1
	else:
		print('Error: Not a valid orbit direction!')

func set_orbit(resource:PhysicalObject):
	node_2d.position = resource.position - get_position_in_world_space()
	node_2d.rotation = resource.rotation - get_rotation_in_world_space()
	orbit_distance = resource.position.length()
	orbit_theta = gravity_force / sqrt(orbit_distance * gravity_force) * get_orbit_direction_mod()

func set_sprite(resource:PhysicalObject):
	sprite.texture = resource.texture
	sprite.scale = resource.scale
	sprite.modulate = resource.color

func _physics_process(delta):
	var rotation_speed = delta * orbit_theta
	node_2d.position = node_2d.position.rotated(rotation_speed)
	if is_instance_valid(player_character):
		var player_distance = node_2d.position.distance_to(player_character.position)
		if player_distance <= LOAD_IN_DISTANCE:
			world_space.spawn_rigid_body_2d(get_physical_object())
			queue_free()
