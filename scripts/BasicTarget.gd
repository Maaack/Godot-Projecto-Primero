extends RigidBody2D

onready var space = get_parent()

export var camera_scale = 1.0
export var linear_delta_limit = 25.0
export var angular_delta_limit = 25.0
export var health = 1000.0
export var prize = 0.0

var spawn_safe_timeout = 0.1
var time_since_spawn = 0.0
var last_linear_velocity = null
var last_angular_velocity = null

var last_damaged_by = null

func _process(delta):
	time_since_spawn += delta
	if not space.is_in_world(position):
		remove_self()
		
func _physics_process(_delta):
	process_physical_limitations()
	last_linear_velocity = get_linear_velocity()
	last_angular_velocity = get_angular_velocity()

func can_remove():
	if spawn_safe_timeout > time_since_spawn:
		return false
	return true

func remove_self():
	if can_remove():
		space.remove_object_path(get_parent(), get_path())

func within_game_space():
	return space.is_in_world(get_position())

func within_linear_velocity_delta():
	if last_linear_velocity == null:
		return true
	var linear_velocity_delta = last_linear_velocity - get_linear_velocity()
	return linear_velocity_delta.length_squared() < pow(linear_delta_limit, 2)

func within_angular_velocity_delta():
	if last_angular_velocity == null:
		return true
	var angular_velocity_delta = last_angular_velocity - get_angular_velocity()
	return angular_velocity_delta < angular_delta_limit

func has_health():
	return health > 0.0
	
func process_physical_limitations():
	if not within_linear_velocity_delta() \
	or not within_angular_velocity_delta() \
	or not within_game_space() \
	or not has_health():
		remove_self()
		
func damage(amount:float, from:Node2D):
	health -= amount
	last_damaged_by = from
	if health < 0.0:
		if last_damaged_by.has_method("reward"):
			last_damaged_by.reward(prize)
		remove_self()
	
func impact(relative_velocity: Vector2, object_mass: float, from: Node2D):
	var impact_force = 0.5 * object_mass * relative_velocity.length_squared()
	var damage = impact_force/1000
	if damage > 0:
		damage(damage, from)

