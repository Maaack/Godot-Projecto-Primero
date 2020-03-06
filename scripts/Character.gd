extends RigidBody2D


const FORWARD_THRUST_MAX = 8.0
const REVERSE_THRUST_MAX = 3.0
const SAS_ANGULAR_VELOCITY_ABS = 10
const SAS_ANGULAR_VELOCITY_ABS_EMERGENCY = 50

onready var camera_2d = $Camera2D
onready var forward_engine = $ForwardEngine
onready var space = get_parent()

# Player Thrust Commands
var is_player_thrusting_forward = false
var is_player_thrusting_backward = false
var is_player_thrusting_right = false
var is_player_thrusting_left = false

# Stability Augmentation System (SAS)
var is_sas_enabled = true
var is_sas_thrusting_forward = false
var is_sas_thrusting_backward = false
var is_sas_thrusting_right = false
var is_sas_thrusting_left = false

# Weapon
var bullet_scene = preload("res://objects/Bullet.tscn")
var is_player_firing_weapon = false
var weapon_delta_since_last_use = 0.0
var weapon_fire_rate_per_second = 8
var weapon_bullet_counter = 0
var weapon_bullet_impulse = 1000.0


func _ready():
	can_sleep = false
	contact_monitor = true
	contacts_reported = 1

func _physics_process(delta):
	process_sas()
	process_weapons(delta)
	
func _integrate_forces(state):
	var final_force_vector = Vector2(0.0, 0.0)
	if is_player_thrusting_forward:
		final_force_vector += Vector2(0.0,-FORWARD_THRUST_MAX).rotated(rotation)
	if is_player_thrusting_backward:
		final_force_vector += Vector2(0.0,REVERSE_THRUST_MAX).rotated(rotation)
	apply_impulse(forward_engine.position.rotated(get_rotation()), final_force_vector)
	if is_player_thrusting_right or is_sas_thrusting_right:
		apply_impulse(Vector2(0,1).rotated(rotation), Vector2(-2,0).rotated(rotation))
		apply_impulse(Vector2(0,-1).rotated(rotation), Vector2(2,0).rotated(rotation))
	if is_player_thrusting_left or is_sas_thrusting_left:
		apply_impulse(Vector2(0,1).rotated(rotation), Vector2(2,0).rotated(rotation))
		apply_impulse(Vector2(0,-1).rotated(rotation), Vector2(-2,0).rotated(rotation))
		
	
func _input(event):
	if event.is_action_pressed("ui_up"):
		is_player_thrusting_forward = true
	elif event.is_action_released("ui_up"):
		is_player_thrusting_forward = false
	if event.is_action_pressed("ui_down"):
		is_player_thrusting_backward = true
	elif event.is_action_released("ui_down"):
		is_player_thrusting_backward = false
	if event.is_action_pressed("ui_right"):
		is_player_thrusting_right = true
	elif event.is_action_released("ui_right"):
		is_player_thrusting_right = false
	if event.is_action_pressed("ui_left"):
		is_player_thrusting_left = true
	elif event.is_action_released("ui_left"):
		is_player_thrusting_left = false
	if event.is_action_pressed("ui_select"):
		is_player_firing_weapon = true
	elif event.is_action_released("ui_select"):
		is_player_firing_weapon = false
	
func reset_sas():
	is_sas_thrusting_left = false
	is_sas_thrusting_right = false
	
func process_sas():
	reset_sas()
	var recommend_thrust_right = false
	var recommend_thrust_left = false
	if angular_velocity > 0.0:
		recommend_thrust_left = true
	if angular_velocity < 0.0:
		recommend_thrust_right = true
	if is_sas_enabled:
		if not is_player_thrusting_left and not is_player_thrusting_right:
			is_sas_thrusting_right = recommend_thrust_right
			is_sas_thrusting_left = recommend_thrust_left

func get_angle_to_target(target_node):
	return get_angle_to(target_node.position)

func spawn_bullet():
	var instance = bullet_scene.instance()
	var bullet_spawn_position = $BulletSpawn.get_position().rotated(get_rotation()) + get_position()
	var final_bullet_impulse = Vector2(0,-1).rotated(get_rotation())*weapon_bullet_impulse
	space.add_child(instance)
	instance.set_position(bullet_spawn_position)
	instance.set_linear_velocity(get_linear_velocity())
	instance.set_rotation(get_rotation())
	instance.apply_central_impulse(final_bullet_impulse)
	apply_central_impulse(-final_bullet_impulse * ( instance.mass / mass ))
	weapon_bullet_counter += 1
	
func process_weapons(delta):
	weapon_delta_since_last_use += delta
	if is_player_firing_weapon:
		if weapon_delta_since_last_use > (1.0 / weapon_fire_rate_per_second) :
			spawn_bullet()
			weapon_delta_since_last_use = 0.0
