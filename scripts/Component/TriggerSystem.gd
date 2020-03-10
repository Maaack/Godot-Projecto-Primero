extends "res://scripts/WorldSpace/Node2D.gd"
	
	
enum TriggerSettingEnum {ONCE, CONTINOUS, CONFIGURABLE}
export(TriggerSettingEnum) var trigger_setting
enum TargetCountSettingEnum {LIMITED, UNLIMITED}
export(TargetCountSettingEnum) var target_count_setting
export(int) var max_target_count = 1
	
export(Array, NodePath) var initial_trigger_output_paths = []
var trigger_outputs = []
var is_triggered = false
var is_triggered_continuous = false
var trigger_once = false setget set_trigger_once
var trigger_time_delta = 0.0
	
func _ready():
	if trigger_setting == TriggerSettingEnum.ONCE:
		trigger_once = true	
	for trigger_output_path in initial_trigger_output_paths:
		var trigger_output = get_node(trigger_output_path)
		add_trigger_output(trigger_output)

func process(delta):
	trigger_time_delta += delta
	if is_triggered:
		for trigger_output in trigger_outputs:
			if trigger_output.has_method("trigger_on"):
				trigger_output.trigger_on()
		reset_trigger()
	else:
		for trigger_output in trigger_outputs:
			if trigger_output.has_method("trigger_off"):
				trigger_output.trigger_off()
			
	
func trigger_on():
	if not trigger_once:
		is_triggered_continuous = true
	is_triggered = true
	
func trigger_off():
	is_triggered = false
	is_triggered_continuous = false
	
func set_trigger_once(value = true):
	if trigger_setting == TriggerSettingEnum.CONFIGURABLE:
		trigger_once = value
	
func set_trigger_contiunous(value = true):
	set_trigger_once(!value)

func reset_trigger():
	is_triggered = is_triggered_continuous
	
func add_trigger_output(trigger_output:Node2D):
	if target_count_setting == TargetCountSettingEnum.LIMITED:
		if trigger_outputs.size() >= max_target_count:
			return
	if trigger_outputs.has(trigger_output):
		return
	trigger_outputs.append(trigger_output)
	
func remove_trigger_output(trigger_output:Node2D):
	if trigger_outputs.has(trigger_output):
		var index = trigger_outputs.find(trigger_output)
		trigger_outputs.remove(index)

func reset_trigger_outputs():
	var new_trigger_outputs = []
	for trigger_output in trigger_outputs:
		if is_instance_valid(trigger_output):
			new_trigger_outputs.append(trigger_output)
	trigger_outputs = new_trigger_outputs
