extends "res://scripts/WorldSpace/Node2D.gd"


func get_physical_owner():
	var parent = get_parent()
	if parent.has_method("get_physical_owner"):
		return get_parent().get_physical_owner()
	else:
		return self
