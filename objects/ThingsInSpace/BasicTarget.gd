extends "res://scripts/Component/Base/Ownable/RigidBody2D.gd"


onready var sprite = $Sprite

export var node_group_name = 'TARGET' setget set_group_name, get_group_name
export var camera_scale = 1.0
export var health = 1000.0
export var prize = 0.0
export var linear_delta_limit = 25.0
export var angular_delta_limit = 5.0
 
var spawn_safe_timeout = 0.1
var time_since_spawn = 0.0
var last_linear_velocity = null
var last_angular_velocity = null
var destroyed = false

var last_damaged_by = null
		
func _physics_process(delta):
	time_since_spawn += delta
	process_physical_limitations()
	last_linear_velocity = get_linear_velocity()
	last_angular_velocity = get_angular_velocity()

func set_group_name(value:String):
	node_group_name = value
	
func get_group_name():
	return node_group_name

func disable_colliders(disable=true):
	for child in get_children():
		if child.has_method("set_disabled"):
			child.set_disabled(disable)

func enable_colliders():
	disable_colliders(false)

func can_destroy():
	if destroyed:
		return false
	if spawn_safe_timeout > time_since_spawn:
		return false
	return true

func destroy_self():
	if can_destroy():
		destroyed = true
		queue_free()

func within_world_space():
	return get_world_space().is_position_in_world_space(get_position_in_world_space())

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
	or not within_world_space() \
	or not has_health():
		destroy_self()
		
func damage(amount:float, from:Node2D):
	var had_health = has_health()
	health -= amount
	last_damaged_by = from
	if not has_health() and had_health:
		if last_damaged_by.has_method("reward"):
			last_damaged_by.reward(prize)
		destroy_self()
	
func impact(relative_velocity: Vector2, object_mass: float, from: Node2D):
	var impact_force = 0.5 * object_mass * relative_velocity.length_squared()
	var damage = impact_force/1000
	if damage > 0:
		damage(damage, from)

