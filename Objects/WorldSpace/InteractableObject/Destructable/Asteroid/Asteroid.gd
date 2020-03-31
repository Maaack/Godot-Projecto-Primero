extends "res://Objects/WorldSpace/InteractableObject/Destructable/Destructable.gd"


func destroy_self():
	world_space.asteroid_counter -= 1
	.destroy_self()

func set_physical_unit(value:PhysicalUnit):
	if value == null:
		return
	sprite_node.modulate = value.color
	.set_physical_unit(value)

func exit_physics_area():
	if not destroyed:
		world_space.put_in_orbit(get_physical_unit())
		destroy_self()
