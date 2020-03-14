extends "res://scripts/Component/Base/TriggerOutputMount.gd"


func load_munition(settings:Dictionary):
	if mounted_system != null and mounted_system.has_method('load_munition'):
		return mounted_system.load_munition(settings)

func set_next_munition(settings:Dictionary):
	if mounted_system != null and mounted_system.has_method('set_next_munition'):
		return mounted_system.set_next_munition(settings)

func is_loaded():
	if mounted_system != null and mounted_system.has_method('is_loaded'):
		return mounted_system.is_loaded()

func is_empty():
	if mounted_system != null and mounted_system.has_method('is_empty'):
		return mounted_system.is_empty()

func get_munitions_stored():
	if mounted_system != null and mounted_system.has_method('get_munitions_stored'):
		return mounted_system.get_munitions_stored()
