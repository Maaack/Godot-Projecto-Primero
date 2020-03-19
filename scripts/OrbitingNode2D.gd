extends "res://scripts/WorldSpace/Node2D.gd"


const LOAD_IN_DISTANCE = 10000.0

onready var node_2d = $Node2D
onready var sprite = $Node2D/Sprite

export(Vector2) var orbit_position
export(float) var orbit_gravity_force
export(PackedScene) var orbit_object_scene
export(Texture) var orbit_object_texture
export(Vector2) var orbit_object_texture_scale
enum OrbitDirectionSetting{CLOCKWISE, COUNTER_CLOCKWISE}
export(OrbitDirectionSetting) var orbit_direction

var orbit_distance
var orbit_theta
var player_character

func _ready():
	reset_orbit()
	reset_object()

func get_orbit_direction_mod():
	if orbit_direction == OrbitDirectionSetting.CLOCKWISE:
		return 1
	elif orbit_direction == OrbitDirectionSetting.COUNTER_CLOCKWISE:
		return -1
	else:
		print('Error: Not a valid orbit direction!')

func reset_orbit():
	set_orbit(orbit_position, orbit_gravity_force)

func set_orbit(node_position:Vector2, gravity_force:float):
	node_2d.position = node_position
	orbit_distance = node_2d.position.length()
	orbit_theta = gravity_force / sqrt(orbit_distance * gravity_force) * get_orbit_direction_mod()

func reset_object():
	set_object(orbit_object_texture, orbit_object_texture_scale)

func set_object(object_texture:Texture, object_scale:Vector2):
	sprite.texture = object_texture
	sprite.scale = object_scale

func _physics_process(delta):
	var rotation_speed = delta * orbit_theta
	node_2d.position = node_2d.position.rotated(rotation_speed)
	if is_instance_valid(player_character):
		var player_distance = node_2d.position.distance_to(player_character.position)
		if player_distance <= LOAD_IN_DISTANCE:
			var relative_position = node_2d.position
			var relative_rotation = node_2d.position.angle()
			var relative_velocity = get_parent().get_orbital_velocity(relative_position) # Reliable?
			var position_in_world = get_position_in_world_space() + relative_position
			var rotation_in_world = get_rotation_in_world_space() + relative_rotation
			world_space.spawn_rigid_body_2d(orbit_object_scene, position_in_world, rotation_in_world, relative_velocity)
			queue_free()
