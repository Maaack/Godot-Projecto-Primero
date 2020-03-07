extends "res://scripts/BasicTarget.gd"


export var armor = 1.0
var legal_owner = null

func _ready():
	set_start_position()
	set_start_velocity()

func set_start_position():
	position = space.get_random_spawn_position()

func set_start_velocity():
	var velocity = space.get_random_space_whale_start_velocity()
	set_axis_velocity(velocity)
	
func remove_self():
	space.asteroid_counter -= 1
	space.remove_object_path(get_parent(), get_path())
	
