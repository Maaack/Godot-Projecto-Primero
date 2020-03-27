extends "res://Objects/WorldSpace/InteractableObject/Component/Mount/TriggerOutputMount.gd"


func integrate_forces(state):
	if mounted_system != null and mounted_system.has_method('integrate_forces'):
		return mounted_system.integrate_forces(state)

