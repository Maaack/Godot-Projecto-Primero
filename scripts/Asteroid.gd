extends RigidBody2D


var space = null
# Called when the node enters the scene tree for the first time.

func set_start_position():
	position = space.get_random_spawn_position()

func set_start_velocity():
	var velocity = space.get_random_space_whale_start_velocity()
	set_axis_velocity(velocity)
	
func remove_self():
	# var node = load("res://Space.gd").new()
	var node = get_parent()
	node.remove_object_path(get_parent(), get_path())
	

func _ready():
	space = get_parent()
	set_start_position()
	set_start_velocity()
	

func _process(delta):
	if not space.is_in_world(position):
		remove_self()
