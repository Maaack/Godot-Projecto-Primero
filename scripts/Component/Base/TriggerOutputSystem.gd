extends "res://scripts/Component/Base/BasicOutputSystem.gd"


enum TriggerSettingEnum {ONCE, CONTINOUS, CONFIGURABLE}
export(TriggerSettingEnum) var trigger_setting

var is_triggered = false
var is_triggered_continuous = false
var trigger_once = false setget set_trigger_once
var trigger_time_delta = 0.0

func _ready():
	if trigger_setting == TriggerSettingEnum.ONCE:
		trigger_once = true

func process(delta):
	trigger_time_delta += delta
	var trigger_outputs = get_output_nodes()
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
