extends "res://Objects/WorldSpace/InteractableObject/Container/RigidBody2D.gd"


func impact(relative_velocity: Vector2, from: Node2D):
	if destructable_manager == null:
		return
	return destructable_manager.impact(relative_velocity, self, from)

func destroy_self():
	if not destroyed:
		if destructable_manager.last_damaged_by and destructable_manager.last_damaged_by.has_method("reward"):
			destructable_manager.last_damaged_by.reward(get_contents_array())
		.destroy_self()
