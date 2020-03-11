extends "res://scripts/Component/Base/BasicSystem.gd"


const BASE_IMPULSE_VECTOR = Vector2(1, 0)
const BASE_ORIENTATION = -PI/2

export var max_engine_impulse = 5.0
onready var engine_wake = $EngineWake
var is_triggered = false

func trigger_on():
	is_triggered = true

func trigger_off():
	is_triggered = false

func integrate_forces(state):
	if is_triggered:
		engine_wake.show()
		var physical_owner = get_physical_owner()
		var rotation_in_world_space = get_rotation_in_world_space()
		var engine_impulse = (BASE_IMPULSE_VECTOR * max_engine_impulse).rotated(rotation_in_world_space).rotated(BASE_ORIENTATION)
		var rotate_offset = physical_owner.get_rotation_in_world_space()
		var impulse_offset = get_position_in_ancestor(physical_owner).rotated(rotate_offset)
		physical_owner.apply_impulse(impulse_offset, engine_impulse)
		trigger_off()
	else:
		engine_wake.hide()
