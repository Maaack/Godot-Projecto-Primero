extends "res://scripts/Component/Base/BasicOutputMount.gd"


func load_munition(munition):
	if mounted_system != null and mounted_system.has_method('load_munition'):
		return mounted_system.load_munition(munition)

func set_next_munition(munition):
	if mounted_system != null and mounted_system.has_method('set_next_munition'):
		return mounted_system.set_next_munition(munition)
