extends RigidBody2D


onready var space = get_parent()

func _ready():
	set_start_position()
	set_start_velocity()

func _process(delta):
	if not space.is_in_world(position):
		remove_self()

func set_start_position():
	position = space.get_random_spawn_position()

func set_start_velocity():
	var velocity = space.get_random_space_whale_start_velocity()
	set_axis_velocity(velocity)
	
func remove_self():
	var node = get_parent()
	space.asteroid_counter -= 1
	node.remove_object_path(get_parent(), get_path())
	
