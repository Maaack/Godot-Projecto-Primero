extends "res://Objects/WorldSpace/InteractableObject/Component/Mount/TriggerOutputMount.gd"


func load_munitions(munitions):
	if mounted_system != null and mounted_system.has_method('load_munitions'):
		return mounted_system.load_munitions(munitions)

func set_next_munition(munition):
	if mounted_system != null and mounted_system.has_method('set_next_munition'):
		return mounted_system.set_next_munition(munition)

func is_loaded():
	if mounted_system != null and mounted_system.has_method('is_loaded'):
		return mounted_system.is_loaded()

func is_empty():
	if mounted_system != null and mounted_system.has_method('is_empty'):
		return mounted_system.is_empty()
