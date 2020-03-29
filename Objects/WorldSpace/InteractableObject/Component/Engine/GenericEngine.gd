extends "res://Objects/WorldSpace/InteractableObject/Node2D.gd"


const BASE_IMPULSE_VECTOR = Vector2(1, 0)
const BASE_ORIENTATION = -PI/2
const MASS_TO_IMPULSE_RATIO = 0.00001

export var max_engine_impulse = 1000.0
export(float, 0, 1) var minimum_throttle = 0.1
export(Resource) var fuel_requirement setget set_fuel_requirement
onready var engine_wake = $EngineWake

var is_triggered = false

func set_fuel_requirement(value:PhysicalCollection):
	if value == null:
		return 
	fuel_requirement = value.duplicate()

func trigger_on():
	is_triggered = true

func trigger_off():
	is_triggered = false

func integrate_forces(state):
	if not is_triggered:
		engine_wake.hide()
		return
	var final_fuel_requirement = get_fuel_requirement()
	var burned_fuel = burn_fuel()
	if burned_fuel == null:
		return
	var burned_ratio = burned_fuel.get_mass() / final_fuel_requirement.get_mass()
	if burned_ratio < minimum_throttle:
		return
	engine_wake.show()
	var physical_owner = get_physical_owner()
	var rotation_in_world_space = get_rotation_in_world_space()
	var total_engine_impulse = burned_ratio * max_engine_impulse
	var engine_impulse_vector = (BASE_IMPULSE_VECTOR * total_engine_impulse).rotated(rotation_in_world_space).rotated(BASE_ORIENTATION)
	var rotate_offset = physical_owner.get_rotation_in_world_space()
	var impulse_offset = get_position_in_ancestor(physical_owner).rotated(rotate_offset)
	physical_owner.apply_impulse(impulse_offset, engine_impulse_vector)
	trigger_off()

func get_fuel_requirement():
	if fuel_requirement == null:
		return
	var physical_quantities = fuel_requirement.physical_quantities.duplicate()
	var engine_mass_ratio = max_engine_impulse * MASS_TO_IMPULSE_RATIO
	var resulting_fuel_requirements = PhysicalCollection.new()
	for physical_quantity in physical_quantities:
		var resulting_physical_quantity = physical_quantity.duplicate()
		var fuel_requirement = physical_quantity.quantity * engine_mass_ratio
		resulting_physical_quantity.quantity = fuel_requirement
		resulting_fuel_requirements.add_physical_quantity(resulting_physical_quantity)
	return resulting_fuel_requirements

func burn_fuel():
	var ship_contents = get_physical_owner().contents
	if ship_contents == null:
		return
	var final_fuel_requirement = get_fuel_requirement()
	if fuel_requirement == null:
		return
	final_fuel_requirement.negate_values()
	var burned_fuel = ship_contents.add_physical_collection(final_fuel_requirement)
	burned_fuel.negate_values()
	return burned_fuel
