extends "res://Objects/WorldSpace/InteractableObject/Component/Mount/TriggerOutputMount.gd"


func integrate_forces(state):
	if is_instance_valid(mounted_system) and mounted_system.has_method('integrate_forces'):
		return mounted_system.integrate_forces(state)

