extends "res://scripts/WorldSpace/WorldSpace.gd"

onready var character = $Character
onready var corvette = $Corvette
onready var simple_rocket = $SimpleRocket
onready var pequod = $Pequod
onready var station = $Station
onready var planet8 = $Planet8
onready var space_whale = $SpaceWhale

export var asteroid_spawn_force_max_y = 1024.0
export var asteroid_spawn_force_min_y = 60.0
export var asteroid_spawn_delay = 5
export var asteroid_spawn_max = 300
export var time_since_last_spawn = 1000.0

var asteroid_preload = preload("res://objects/Asteroid.tscn")
var asteroid_counter = 0


func get_random_spawn_position():
	return get_random_position_in_world_space()
	
func get_random_space_whale_start_velocity():
	var start_force_y = rand_range(asteroid_spawn_force_min_y, asteroid_spawn_force_max_y)
	return Vector2(0.0, -start_force_y)


func _process(delta):
	time_since_last_spawn += delta
	if asteroid_counter < asteroid_spawn_max:
		if time_since_last_spawn >= asteroid_spawn_delay:
			time_since_last_spawn -= asteroid_spawn_delay
			var instance = asteroid_preload.instance()
			add_child(instance)
			instance.set_position(get_random_position_in_world_space())
			instance.set_axis_velocity(get_random_space_whale_start_velocity())
			asteroid_counter += 1
