extends Node2D

const WORLD_SIZE_X = 4096.0
const WORLD_SIZE_Y = 4096.0
const WORLD_SIZE_MULTIPLIER = 40.0
const SPAWN_FORCE_MAX_Y = 1024.0
const SPAWN_FORCE_MIN_Y = 60.0
const PRINT_POSITION_DELAY = 5.0
const ASTEROID_SPAWN_DELAY = 5
const ASTEROID_SPAWN_MAX = 300

onready var character = $Corvette
onready var corvette = $Corvette
onready var pequod = $Pequod
onready var station = $Station
onready var planet8 = $Planet8
onready var space_whale = $SpaceWhale

var time_since_last_spawn = 1250.0
var asteroid_preload = preload("res://objects/Meteor.tscn")
var asteroid_counter = 0


func get_random_spawn_position():
	var world_size = get_world_size()
	var start_position_x = rand_range(-world_size.x, world_size.x)
	var start_position_y = rand_range(-world_size.y, world_size.y)
	return Vector2(start_position_x, start_position_y)
	
func get_random_space_whale_start_velocity():
	var start_force_y = rand_range(SPAWN_FORCE_MIN_Y, SPAWN_FORCE_MAX_Y)
	return Vector2(0.0, -start_force_y)

func get_world_size():
	var world_x = WORLD_SIZE_X * WORLD_SIZE_MULTIPLIER
	var world_y = WORLD_SIZE_Y * WORLD_SIZE_MULTIPLIER
	return Vector2(world_x, world_y)


func is_in_world(position):
	var world_size = get_world_size()
	if abs(position.x) > world_size.x:
		return false
	if abs(position.y) > world_size.y:
		return false
	return true

func _process(delta):
	time_since_last_spawn += delta
	if asteroid_counter < ASTEROID_SPAWN_MAX:
		if time_since_last_spawn >= ASTEROID_SPAWN_DELAY:
			time_since_last_spawn -= ASTEROID_SPAWN_DELAY
			var instance = asteroid_preload.instance()
			add_child(instance)
			asteroid_counter += 1

func remove_object_path(parent_node, object_path):
	parent_node.get_node(object_path).queue_free()
	
