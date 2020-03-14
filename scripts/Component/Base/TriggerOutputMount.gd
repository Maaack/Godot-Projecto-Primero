extends "res://scripts/Component/Base/BasicOutputMount.gd"


func is_compatible(system:Node2D):
	return system.has_method("trigger_on") and system.has_method("trigger_off")

func trigger_on():
	if is_mounted() and mounted_system.has_method("trigger_on"):
		mounted_system.trigger_on()

func trigger_off():
	if is_mounted() and mounted_system.has_method("trigger_off"):
		mounted_system.trigger_off()

func get_munitions_stored():
		if is_mounted() and mounted_system.has_method("get_munitions_stored"):
			return mounted_system.get_munitions_stored()
