extends "res://scripts/Component/Base/BasicOutputMount.gd"


func load_munition(settings:Dictionary):
	if mounted_system != null and mounted_system.has_method('load_munition'):
		return mounted_system.load_munition(settings)

func set_next_munition(settings:Dictionary):
	if mounted_system != null and mounted_system.has_method('set_next_munition'):
		return mounted_system.set_next_munition(settings)

func get_munitions_stored():
	if mounted_system != null and mounted_system.has_method('get_munitions_stored'):
		return mounted_system.get_munitions_stored()
