extends RigidBody2D


const FORWARD_THRUST_MAX = 10.0
const SAS_ANGULAR_VELOCITY_ABS = 10
const SAS_ANGULAR_VELOCITY_ABS_EMERGENCY = 50
var is_player_thrusting_forward = false
var is_player_thrusting_backward = false
var is_player_thrusting_right = false
var is_player_thrusting_left = false

# Stability Augmentation System
var is_sas_enabled = true
var is_sas_thrusting_forward = false
var is_sas_thrusting_backward = false
var is_sas_thrusting_right = false
var is_sas_thrusting_left = false

#var target_node = null
#var target_nodes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
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
	
func reset_sas():
	is_sas_thrusting_left = false
	is_sas_thrusting_right = false
	
func run_sas(state):
	reset_sas()
	var recommend_thrust_right = false
	var recommend_thrust_left = false
	if state.angular_velocity > 0.0:
		recommend_thrust_left = true
	if state.angular_velocity < 0.0:
		recommend_thrust_right = true
	if is_sas_enabled:
		if not is_player_thrusting_left and not is_player_thrusting_right:
			is_sas_thrusting_right = recommend_thrust_right
			is_sas_thrusting_left = recommend_thrust_left

func get_angle_to_target(target_node):
	return get_angle_to(target_node.position)

func _physics_process(delta):
	run_sas(self)
	var additional_force_vector = Vector2(0.0, 0.0)
	if is_player_thrusting_forward:
		additional_force_vector += Vector2(0,-5).rotated(rotation)
	if is_player_thrusting_backward:
		additional_force_vector += Vector2(0,5).rotated(rotation)
	apply_central_impulse(additional_force_vector)
	if is_player_thrusting_right or is_sas_thrusting_right:
		apply_impulse(Vector2(0,1).rotated(rotation), Vector2(-1,0).rotated(rotation))
		apply_impulse(Vector2(0,-1).rotated(rotation), Vector2(1,0).rotated(rotation))
	if is_player_thrusting_left or is_sas_thrusting_left:
		apply_impulse(Vector2(0,1).rotated(rotation), Vector2(1,0).rotated(rotation))
		apply_impulse(Vector2(0,-1).rotated(rotation), Vector2(-1,0).rotated(rotation))
		
