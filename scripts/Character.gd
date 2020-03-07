extends RigidBody2D


const FORWARD_THRUST_MAX = 8.0
const REVERSE_THRUST_MAX = 3.0
const SAS_ANGULAR_VELOCITY_ABS = 10
const SAS_ANGULAR_VELOCITY_ABS_EMERGENCY = 50

onready var camera_2d = $Camera2D
onready var forward_engine = $ForwardEngine
onready var front_weapon = $FrontWeapon
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
var tracer_scene = preload("res://objects/Tracer.tscn")
var is_player_firing_weapon = false
var weapon_fire_time_delta = 0.0
var weapon_fire_rate_per_second = 8
var weapon_tracer_time_delta = 0.0
var weapon_tracer_rate_per_second = 1
var weapon_bullet_impulse = 1000.0

var tracer_list = []

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
	state.apply_impulse(forward_engine.position.rotated(get_rotation()), final_force_vector)
	if is_player_thrusting_right or is_sas_thrusting_right:
		state.apply_impulse(Vector2(0,1).rotated(rotation), Vector2(-2,0).rotated(rotation))
		state.apply_impulse(Vector2(0,-1).rotated(rotation), Vector2(2,0).rotated(rotation))
	if is_player_thrusting_left or is_sas_thrusting_left:
		state.apply_impulse(Vector2(0,1).rotated(rotation), Vector2(2,0).rotated(rotation))
		state.apply_impulse(Vector2(0,-1).rotated(rotation), Vector2(-2,0).rotated(rotation))
		
	
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

func spawn_bullet(is_tracer_round:bool):
	var instance = bullet_scene.instance()
	var bullet_spawn_position = front_weapon.get_position().rotated(get_rotation()) + get_position()
	var final_bullet_impulse = Vector2(0,-1).rotated(get_rotation())*weapon_bullet_impulse
	space.add_child(instance)
	instance.set_position(bullet_spawn_position)
	instance.set_linear_velocity(get_linear_velocity())
	instance.set_rotation(get_rotation())
	instance.apply_central_impulse(final_bullet_impulse)
	if (is_tracer_round):
		add_tracer(instance)
	apply_central_impulse(-final_bullet_impulse * ( instance.mass / mass ))
	
func add_tracer(object:Node2D):
	var instance = tracer_scene.instance()
	space.add_child(instance)
	instance.set_attached_to(object)
	get_tracer_list().append(instance)
	
func get_tracer_list():
	var new_tracer_list = []
	for tracer in tracer_list:
		if is_instance_valid(tracer):
			new_tracer_list.append(tracer)
	tracer_list = new_tracer_list
	return tracer_list
	
func process_weapons(delta):
	weapon_fire_time_delta += delta
	weapon_tracer_time_delta += delta
	if is_player_firing_weapon:
		if weapon_fire_time_delta > (1.0 / weapon_fire_rate_per_second) :
			var is_tracer_round = false
			if weapon_tracer_time_delta > (1.0 / weapon_tracer_rate_per_second):
				is_tracer_round = true
				weapon_tracer_time_delta = 0.0
			spawn_bullet(is_tracer_round)
			weapon_fire_time_delta = 0.0
