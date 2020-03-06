extends RigidBody2D

onready var camera_2d = $Camera2D
onready var space = get_parent()

export var linear_delta_limit = 10.0
export var angular_delta_limit = 10.0
var spawn_safe_timeout = 0.1
var time_since_spawn = 0.0
var last_linear_velocity = null
var last_angular_velocity = null

func _process(delta):
	time_since_spawn += delta
	if not space.is_in_world(position):
		remove_self()
		
func _physics_process(delta):
	if has_exceeded_physical_limitations():
		remove_self()
	last_linear_velocity = get_linear_velocity()
	last_angular_velocity = get_angular_velocity()

func can_remove():
	if spawn_safe_timeout > time_since_spawn:
		return false
	return true

func remove_self():
	if can_remove():
		space.remove_object_path(get_parent(), get_path())

func has_exceeded_physical_limitations():
	return has_exceeded_linear_velocity_delta() or has_exceeded_angular_velocity_delta()
	
func has_exceeded_linear_velocity_delta():
	if last_linear_velocity == null:
		return false
	var linear_velocity_delta = last_linear_velocity - get_linear_velocity()
	return linear_velocity_delta.length_squared() > pow(linear_delta_limit, 2)

func has_exceeded_angular_velocity_delta():
	if last_angular_velocity == null:
		return false
	var angular_velocity_delta = last_angular_velocity - get_angular_velocity()
	return angular_velocity_delta > angular_delta_limit
