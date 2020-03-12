extends "res://scripts/WorldSpace/RigidBody2D.gd"


const BASE_ORIENTATION = PI/2
const SAS_ANGULAR_VELOCITY_ABS = 10
const SAS_ANGULAR_VELOCITY_ABS_EMERGENCY = 50

onready var space = get_parent()

export var camera_scale = 1.0
onready var engine_system = $FourGroupEnginesMount
onready var engine_mounts = [
	$ForwardLeftEngineMount,
	$ForwardCenterEngineMount,
	$ForwardRightEngineMount,
	$ReverseLeftEngineMount,
	$ReverseRightEngineMount,
]

onready var weapons_system = $WeaponsSystemMount
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

func _physics_process(delta):
	weapons_system.process(delta)
	for weapon_mount in weapon_mounts:
		weapon_mount.process(delta)
	engine_system.process(delta)

func _integrate_forces(state):
	for engine_mount in engine_mounts:
		engine_mount.integrate_forces(state)
		
func _input(event):
	if event.is_action_pressed("ui_up"):
		engine_system.trigger_forward_on()
	elif event.is_action_released("ui_up"):
		engine_system.trigger_forward_off()
	if event.is_action_pressed("ui_down"):
		engine_system.trigger_reverse_on()
	elif event.is_action_released("ui_down"):
		engine_system.trigger_reverse_off()
	if event.is_action_pressed("ui_right"):
		engine_system.trigger_right_spin_on()
	elif event.is_action_released("ui_right"):
		engine_system.trigger_right_spin_off()
	if event.is_action_pressed("ui_left"):
		engine_system.trigger_left_spin_on()
	elif event.is_action_released("ui_left"):
		engine_system.trigger_left_spin_off()
	if event.is_action_pressed("ui_select"):
		weapons_system.trigger_on()
	elif event.is_action_released("ui_select"):
		weapons_system.trigger_off()

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
