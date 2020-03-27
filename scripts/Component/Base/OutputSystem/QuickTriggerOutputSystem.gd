extends "res://scripts/Component/Base/OutputSystem/BasicOutputSystem.gd"


func trigger_on():
	var trigger_outputs = get_output_nodes()
	for trigger_output in trigger_outputs:
		if trigger_output.has_method("trigger_on"):
			trigger_output.trigger_on()

func trigger_off():
	var trigger_outputs = get_output_nodes()
	for trigger_output in trigger_outputs:
		if trigger_output.has_method("trigger_off"):
			trigger_output.trigger_off()
