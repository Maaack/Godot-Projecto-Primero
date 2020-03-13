extends "res://scripts/WorldSpace/Node2D.gd"


var legal_owner = null setget set_legal_owner, get_legal_owner

func get_legal_owner():
	var parent = get_parent()
	if parent.has_method("get_legal_owner"):
		var parent_legal_owner = get_parent().get_legal_owner()
		if parent_legal_owner != null:
			legal_owner = parent_legal_owner
	return legal_owner

func set_legal_owner(value):
	if is_instance_valid(value):
		legal_owner = value

func get_physical_owner():
	var parent = get_parent()
	if parent.has_method("get_physical_owner"):
		return get_parent().get_physical_owner()
	else:
		return self
