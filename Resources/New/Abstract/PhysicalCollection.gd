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
	
func get_quantity_key(value:PhysicalQuantity):
	if value == null:
		return
	return value.physical_unit.group_name

func reset_key_map():
	physical_quantities_dict.clear()
	for physical_quantity in physical_quantities:
		if physical_quantity.physical_unit != null:
			var key = get_quantity_key(physical_quantity)
			physical_quantities_dict[key] = physical_quantity

func get_physical_quantity(key:String):
	if physical_quantities_dict.has(key):
		return physical_quantities_dict[key]

func get_quantity_value(key:String):
	var physical_quantity = get_physical_quantity(key)
	if physical_quantity != null:
		return physical_quantity.quantity
	return 0.0

func get_total_quantity_value():
	var total_quantity = 0.0
	for key in physical_quantities_dict:
		var physical_quantity = physical_quantities_dict[key]
		total_quantity += physical_quantity.quantity
	return total_quantity

func get_empty_quantity_value():
	return get_quantity_value(EMPTY_GROUP_NAME)

func get_empty_quantity():
	return get_physical_quantity(EMPTY_GROUP_NAME)

func add_units_by_key(key:String, value:float):
	if not physical_quantities_dict.has(key):
		return
	if value == 0.0:
		return
	var physical_quantity = physical_quantities_dict[key]
	physical_quantity.quantity += value
	if physical_quantity.quantity == -0:
		physical_quantity.quantity = 0
	if key != EMPTY_GROUP_NAME:
		var physical_quantity_dup = physical_quantity.duplicate()
		physical_quantity_dup.quantity = value
		fill_space(physical_quantity_dup)
	return physical_quantity.quantity

func add_physical_quantity(value:PhysicalQuantity):
	if value == null:
		return
	value = value.duplicate()
	var key = get_quantity_key(value)
	var empty_space = get_empty_space()
	if value.quantity > 0 and empty_space != null:
		var unit_area = get_unit_area(value)
		var quantity_space = value.quantity * unit_area
		var max_space = min(empty_space, quantity_space)
		value.quantity = max_space / unit_area
	elif value.quantity < 0:
		if not physical_quantities_dict.has(key):
			return
		var current_quantity = physical_quantities_dict[key]
		value.quantity = max(-current_quantity.quantity, value.quantity)
	if value.physical_unit.numerical_unit == value.physical_unit.NumericalUnitSetting.DISCRETE:
		value.quantity = floor(value.quantity)
	var total = add_units_by_key(key, value.quantity)
	if total == null:
		if value.quantity > 0:
			physical_quantities.append(value)
			physical_quantities_dict[key] = value
			fill_space(value)

func fill_space(value:PhysicalQuantity):
	var area_mod = get_area_mod(value)
	var quantity_space = value.quantity * area_mod
	add_units_by_key(EMPTY_GROUP_NAME, -(quantity_space))

func get_area_mod(value:PhysicalQuantity):
	var empty_quantity = get_empty_quantity()
	if empty_quantity == null:
		return 1
	return get_unit_area(value) / get_unit_area(empty_quantity)

func get_unit_area(value:PhysicalQuantity):
	return value.physical_unit.size.x * value.physical_unit.size.y

func get_empty_space():
	var empty_quantity = get_empty_quantity()
	if empty_quantity == null:
		return
	return get_unit_area(empty_quantity) * empty_quantity.quantity

