extends "res://Objects/WorldSpace/Node2D.gd"


const LOAD_IN_DISTANCE = 10000.0

onready var node_2d = $Node2D
onready var sprite = $Node2D/Sprite

export(float) var gravity_force

enum OrbitDirectionSetting{CLOCKWISE, COUNTER_CLOCKWISE}
export(OrbitDirectionSetting) var orbit_direction

var orbit_distance
var orbit_theta
var player_character


func set_physical_unit(value:PhysicalUnit):
	if value == null:
		return
	if not value is PackedSceneUnit:
		return
	set_orbit(value)
	set_sprite(value)

func get_physical_unit():
	var value = node_2d.get_physical_unit()
	if value == null:
		return
	value.linear_velocity = get_parent().get_orbital_velocity(node_2d.position)
	return value

func get_orbit_direction_mod():
	if orbit_direction == OrbitDirectionSetting.CLOCKWISE:
		return 1
	elif orbit_direction == OrbitDirectionSetting.COUNTER_CLOCKWISE:
		return -1
	else:
		print('Error: Not a valid orbit direction!')

func set_orbit(value:PackedSceneUnit):
	value.position -= get_position_in_world_space()
	value.rotation -= get_rotation_in_world_space()
	node_2d.physical_unit = value
	orbit_distance = node_2d.position.length()
	if gravity_force * orbit_distance == 0:
		orbit_theta = 0
		return
	orbit_theta = gravity_force / sqrt(orbit_distance * gravity_force) * get_orbit_direction_mod()

func set_sprite(value:PhysicalUnit):
	sprite.texture = value.texture
	sprite.scale = value.scale
	sprite.modulate = value.color

func _physics_process(delta):
	var rotation_speed = delta * orbit_theta
	node_2d.position = node_2d.position.rotated(rotation_speed)
	if is_instance_valid(player_character):
		var player_distance = node_2d.position.distance_to(player_character.position)
		if player_distance <= LOAD_IN_DISTANCE:
			world_space.spawn_rigid_body_2d(get_physical_unit())
			queue_free()
