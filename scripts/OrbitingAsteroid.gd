extends "res://scripts/WorldSpace/Node2D.gd"


onready var asteroid = $BackgroundAsteroid
export(Vector2) var initial_position
export(float) var initial_gravity_force

var orbit_gravity_force
var orbit_distance
var orbit_theta
var player_character

func _ready():
	set_orbit(initial_position, initial_gravity_force)

func set_orbit(asteroid_position:Vector2, gravity_force):
	asteroid.position = asteroid_position	
	orbit_gravity_force = gravity_force
	orbit_distance = asteroid.position.length()
	orbit_theta = gravity_force / sqrt(orbit_distance * gravity_force)

func _physics_process(delta):
	var rotation_speed = delta * orbit_theta
	asteroid.position = asteroid.position.rotated(rotation_speed)
	if is_instance_valid(player_character):
		var player_distance = asteroid.position.distance_to(player_character.position)
		if player_distance <= 10000.0:
			get_parent().spawn_asteroid(asteroid.position)
			queue_free()
