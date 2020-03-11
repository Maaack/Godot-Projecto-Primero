extends "res://scripts/Component/Base/BasicOutputSystem.gd"
	
	
export(float) var timer = 0.0
enum ResetSettingEnum {ONCE, REPEATING}
export(ResetSettingEnum) var reset_setting

var trigger_time_delta = 0.0

func process(delta):
	trigger_time_delta += delta
	var trigger_outputs = get_output_nodes()
	if get_time_left() < 0:
		for trigger_output in trigger_outputs:
			if trigger_output.has_method("trigger_on"):
				trigger_output.trigger_on()
		if reset_setting == ResetSettingEnum.REPEATING:
			reset_timer()
	else:
		for trigger_output in trigger_outputs:
			if trigger_output.has_method("trigger_off"):
				trigger_output.trigger_off()

func get_time_left():
	return timer - trigger_time_delta

func reset_timer():
	trigger_time_delta = 0.0
