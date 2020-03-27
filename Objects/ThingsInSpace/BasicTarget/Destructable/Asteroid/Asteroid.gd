extends "res://Objects/ThingsInSpace/BasicTarget/Destructable/Destructable.gd"


const LOAD_OUT_DISTANCE = 15000.0

func destroy_self():
	if can_destroy():
		world_space.asteroid_counter -= 1
		.destroy_self()

func set_physical_unit(value:PhysicalUnit):
	if value == null:
		return
	sprite.modulate = value.color
	.set_physical_unit(value)

func _physics_process(delta):
	if position.distance_to(world_space.character.position) > LOAD_OUT_DISTANCE:
		world_space.put_in_orbit(get_physical_unit())
		destroy_self()
