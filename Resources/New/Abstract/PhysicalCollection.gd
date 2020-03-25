extends Resource


class_name PhysicalCollection

const EMPTY_GROUP_NAME = 'EMPTY'

export(Array, Resource) var physical_quantities setget set_physical_quantities

var physical_quantities_dict = {}

func set_physical_quantities(value:Array):
	if value == null:
		return
	physical_quantities = value
	reset_key_map()

func reset_key_map():
	physical_quantities_dict.clear()
	for physical_quantity in physical_quantities:
		if physical_quantity.physical_unit != null:
			var key = physical_quantity.physical_unit.group_name
			physical_quantities_dict[key] = physical_quantity

func get_quantity_by_key(key:String):
	if physical_quantities_dict.has(key):
		return physical_quantities_dict[key].quantity
	return 0.0

func get_total_quantity():
	var total_quantity = 0.0
	for physical_quantity in physical_quantities_dict:
		total_quantity += physical_quantity.quantity
	return total_quantity
	
func get_empty_quantity():
	return get_quantity_by_key(EMPTY_GROUP_NAME)

func add_units_by_key(key:String, value:float):
	if not physical_quantities_dict.has(key):
		return
	var physical_quantity = physical_quantities_dict[key]
	physical_quantity.quantity += value
	if key != EMPTY_GROUP_NAME:
		add_units_by_key(EMPTY_GROUP_NAME, -(value))
	return physical_quantity.quantity

func add_units(unit:PhysicalUnit, value:float):
	var key = unit.group_name
	var total = add_units_by_key(key, value)
	if total == null:
		if value > 0:
			physical_quantities_dict[key] = PhysicalQuantity.new(unit, value)
			add_units_by_key(EMPTY_GROUP_NAME, -(value))
