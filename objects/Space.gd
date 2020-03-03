extends Node2D


onready var character = $Character
onready var station = $Station
onready var planet8 = $Planet8

const WORLD_SIZE_X = 4096.0
const WORLD_SIZE_Y = 4096.0
const WORLD_SIZE_MULTIPLIER = 10.0
const SPAWN_POSITION_ABS_X = 10240.0
const SPAWN_POSITION_ABS_Y = 10240.0
const SPAWN_FORCE_MAX_Y = 120.0
const SPAWN_FORCE_MIN_Y = 30.0
const PRINT_POSITION_DELAY = 5.0
const WHALE_SPAWN_DELAY = 5
var time_since_last_spawn = 60.0
var meteor_preload = preload("res://objects/Meteor.tscn")

func get_random_spawn_position():
	var start_position_x = rand_range(-SPAWN_POSITION_ABS_X, SPAWN_POSITION_ABS_X)
	var start_position_y = rand_range(-SPAWN_POSITION_ABS_Y, SPAWN_POSITION_ABS_Y)
	return Vector2(start_position_x, start_position_y)
	
func get_random_space_whale_start_velocity():
	var start_force_y = rand_range(SPAWN_FORCE_MIN_Y, SPAWN_FORCE_MAX_Y)
	return Vector2(0.0, -start_force_y)

func is_in_world(position):
	var world_max_x = WORLD_SIZE_X * WORLD_SIZE_MULTIPLIER
	var world_max_y = WORLD_SIZE_Y * WORLD_SIZE_MULTIPLIER
	if abs(position.x) > world_max_x:
		return false
	if abs(position.y) > world_max_y:
		return false
	return true

# Called when the node enters the scene tree for the first time.
func _ready():
	character.target_node = station
	character.target_nodes.append(station)
	character.target_nodes.append(planet8)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_since_last_spawn += delta
	if time_since_last_spawn >= WHALE_SPAWN_DELAY:
		time_since_last_spawn -= WHALE_SPAWN_DELAY
		var instance = meteor_preload.instance()
		add_child(instance)

func remove_object_path(parent_node, object_path):
	parent_node.get_node(object_path).queue_free()
	
