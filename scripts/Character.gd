extends "res://scripts/WorldSpace/RigidBody2D.gd"


const FORWARD_THRUST_MAX = 8.0
const REVERSE_THRUST_MAX = 3.0
const SAS_ANGULAR_VELOCITY_ABS = 10
const SAS_ANGULAR_VELOCITY_ABS_EMERGENCY = 50

onready var forward_engine = $ForwardEngine
onready var space = get_parent()

export var camera_scale = 1.0

onready var weapons_system = $WeaponsSystem
onready var weapon_mounts = [
	$FrontLeftHardpoint,
	$FrontRightHardpoint
]

# Player Thrust Commands
var is_player_thrusting_forward = false
var is_player_thrusting_backward = false
var is_player_thrusting_right = false
var is_player_thrusting_left = false
var is_player_firing = false

# Stability Augmentation System (SAS)
var is_sas_enabled = true
var is_sas_thrusting_forward = false
var is_sas_thrusting_backward = false
var is_sas_thrusting_right = false
var is_sas_thrusting_left = false

var tracer_list = []

# Currency
export var money = 0.0


func _ready():
	can_sleep = false
	contact_monitor = true
	contacts_reported = 1

func _physics_process(delta):
	process_sas()
	weapons_system.process(delta)
	for weapon_mount in weapon_mounts:
		weapon_mount.process(delta)

	
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
		is_player_firing = true
		weapons_system.trigger_on()
	elif event.is_action_released("ui_select"):
		is_player_firing = false
		weapons_system.trigger_off()

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
	
func get_tracer_list():
	var new_tracer_list = []
	for tracer in tracer_list:
		if is_instance_valid(tracer):
			new_tracer_list.append(tracer)
	tracer_list = new_tracer_list
	return tracer_list

func reward(amount:float):
	money += amount

func get_physical_owner():
	return self
