extends "res://scripts/Component/Base/BasicSystem.gd"


onready var forward_engines = $ForwardEngineTriggerMount
onready var reverse_engines = $ReverseEngineTriggerMount
onready var right_spin_engines = $RightSpinEngineTriggerMount
onready var left_spin_engines = $LeftSpinEngineTriggerMount

var is_forward_triggered = false
var is_reverse_triggered = false
var is_right_spin_triggered = false
var is_left_spin_triggered = false

func process(delta):
	process_triggers(delta)
	process_engine_outputs(delta)

func process_triggers(delta):
	if is_forward_triggered:
		forward_engines.trigger_on()
	elif is_reverse_triggered:
		reverse_engines.trigger_on()
	if is_right_spin_triggered:
		right_spin_engines.trigger_on()
	elif is_left_spin_triggered:
		left_spin_engines.trigger_on()

func process_engine_outputs(delta):
	forward_engines.process(delta)
	reverse_engines.process(delta)
	right_spin_engines.process(delta)
	left_spin_engines.process(delta)

func set_forward_engines(engines):
	forward_engines.set_output_nodes(engines)

func set_reverse_engines(engines):
	reverse_engines.set_output_nodes(engines)

func set_right_spin_engines(engines):
	right_spin_engines.set_output_nodes(engines)

func set_left_spin_engines(engines):
	left_spin_engines.set_output_nodes(engines)

func trigger_forward_on():
	is_forward_triggered = true

func trigger_forward_off():
	is_forward_triggered = false

func trigger_reverse_on():
	is_reverse_triggered = true

func trigger_reverse_off():
	is_reverse_triggered = false

func trigger_right_spin_on():
	is_right_spin_triggered = true

func trigger_right_spin_off():
	is_right_spin_triggered = false

func trigger_left_spin_on():
	is_left_spin_triggered = true

func trigger_left_spin_off():
	is_left_spin_triggered = false
