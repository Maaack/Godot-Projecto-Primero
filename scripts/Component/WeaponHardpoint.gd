extends "res://scripts/Component/Base/TriggerOutputMount.gd"


func load_munition(settings:Dictionary):
	if mounted_system != null and mounted_system.has_method('load_munition'):
		return mounted_system.load_munition(settings)
