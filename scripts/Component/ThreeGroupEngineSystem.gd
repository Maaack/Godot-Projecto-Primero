extends "res://Objects/WorldSpace/Ownable/Node2D.gd"


onready var forward_engines = $ForwardEngineTriggerMount
onready var right_spin_engines = $RightSpinEngineTriggerMount
onready var left_spin_engines = $LeftSpinEngineTriggerMount

export(bool) var is_sas_enabled = true
var sas_angular_velocity_min = PI/66
var sas_angular_velocity_max = PI*4
var sas_angular_velocity_emergency_reset = PI*2
var is_forward_triggered = false
var is_right_spin_triggered = false
var is_left_spin_triggered = false
var is_right_spin_sas_triggered = false
var is_left_spin_sas_triggered = false
var is_right_spin_sas_emergency_triggered = false
var is_left_spin_sas_emergency_triggered = false

func process(delta):
	process_sas()
	process_triggers(delta)
	process_engine_outputs(delta)

func process_triggers(delta):
	if is_forward_triggered:
		forward_engines.trigger_on()
	if is_right_spin_triggered or is_right_spin_sas_triggered:
		right_spin_engines.trigger_on()
	elif is_left_spin_triggered or is_left_spin_sas_triggered:
		left_spin_engines.trigger_on()
	if is_right_spin_sas_emergency_triggered:
		left_spin_engines.trigger_off()
		right_spin_engines.trigger_on()
	elif is_left_spin_sas_emergency_triggered:
		right_spin_engines.trigger_off()
		left_spin_engines.trigger_on()

func process_engine_outputs(delta):
	forward_engines.process(delta)
	right_spin_engines.process(delta)
	left_spin_engines.process(delta)

func process_sas():
	is_right_spin_sas_triggered = false
	is_left_spin_sas_triggered = false
	var angular_velocity = get_physical_owner().angular_velocity
	var spinning_right = false
	var spinning_left = false
	if angular_velocity > sas_angular_velocity_min:
		spinning_right = true
	if angular_velocity < -sas_angular_velocity_min:
		spinning_left = true
	if is_sas_enabled:
		if not is_right_spin_triggered and not is_left_spin_triggered:
			is_right_spin_sas_triggered = spinning_left
			is_left_spin_sas_triggered = spinning_right
		if abs(angular_velocity) < sas_angular_velocity_emergency_reset:
			is_right_spin_sas_emergency_triggered = false
			is_left_spin_sas_emergency_triggered = false
		if abs(angular_velocity) > sas_angular_velocity_max:
			is_right_spin_sas_emergency_triggered = spinning_left
			is_left_spin_sas_emergency_triggered = spinning_right
			

func set_forward_engines(engines):
	forward_engines.set_output_nodes(engines)

func set_right_spin_engines(engines):
	right_spin_engines.set_output_nodes(engines)

func set_left_spin_engines(engines):
	left_spin_engines.set_output_nodes(engines)

func trigger_forward_on():
	is_forward_triggered = true

func trigger_forward_off():
	is_forward_triggered = false

func trigger_right_spin_on():
	is_right_spin_triggered = true

func trigger_right_spin_off():
	is_right_spin_triggered = false

func trigger_left_spin_on():
	is_left_spin_triggered = true

func trigger_left_spin_off():
	is_left_spin_triggered = false
