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
	if value == null or value.physical_unit == null:
		return
	return value.physical_unit.group_name

func reset_key_map():
	physical_quantities_dict.clear()
	for physical_quantity in physical_quantities:
		if physical_quantity.physical_unit != null:
			var key = get_quantity_key(physical_quantity)
			if key == null:
				continue
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

func add_quantity_value(key:String, value:float, ignore_empty=false):
	if not physical_quantities_dict.has(key):
		return
	if value == 0.0:
		return
	var physical_quantity = physical_quantities_dict[key]
	physical_quantity.quantity += value
	if physical_quantity.quantity == -0:
		physical_quantity.quantity = 0
	if key != EMPTY_GROUP_NAME and not ignore_empty:
		var physical_quantity_dup = physical_quantity.duplicate()
		physical_quantity_dup.quantity = value
		fill_space(physical_quantity_dup)
	return physical_quantity.quantity

func append_physical_quantity(value:PhysicalQuantity, key=null, ignore_empty=false):
	if value == null:
		return
	if key == null:
		key = get_quantity_key(value)
		if key == null:
			return
	physical_quantities.append(value)
	physical_quantities_dict[key] = value
	if not ignore_empty:
		fill_space(value)
	return value

func negate_values():
	for physical_quantity in physical_quantities:
		physical_quantity.quantity = -(physical_quantity.quantity)

func add_physical_collection(value:PhysicalCollection, ignore_empty=false):
	if value == null:
		return
	value = value.duplicate()
	for physical_quantity in value.physical_quantities:
		add_physical_quantity(physical_quantity, ignore_empty)
	return value

func add_physical_quantity(value:PhysicalQuantity, ignore_empty=false):
	if value == null:
		return
	value = value.duplicate()
	var key = get_quantity_key(value)
	if value.quantity > 0 and not ignore_empty:
		value.quantity = get_max_quantity_from_empty_space(value)
	elif value.quantity < 0:
		var max_quantity = get_max_quantity_from_existing_quantity(key, value)
		if max_quantity == null:
			return
		value.quantity = max_quantity
	if value.quantity == 0:
		return value
	var total = add_quantity_value(key, value.quantity, ignore_empty)
	if total != null:
		return value
	if value.quantity > 0:
		return append_physical_quantity(value, key, ignore_empty)

func get_max_quantity_from_empty_space(value:PhysicalQuantity):
	var empty_space = get_empty_space()
	if empty_space == null:
		return value.quantity
	var unit_area = value.get_unit_area()
	var quantity_space = value.get_area()
	var max_space = min(empty_space, quantity_space)
	return max_space / unit_area

func get_max_quantity_from_existing_quantity(key, value:PhysicalQuantity):
	if not physical_quantities_dict.has(key):
		return
	var current_quantity = physical_quantities_dict[key]
	return max(-current_quantity.quantity, value.quantity)
		
func fill_space(value:PhysicalQuantity):
	var area_mod = get_area_mod(value)
	var quantity_empty = value.quantity * area_mod
	add_quantity_value(EMPTY_GROUP_NAME, -(quantity_empty))

func get_area_mod(value:PhysicalQuantity):
	var empty_quantity = get_empty_quantity()
	if empty_quantity == null:
		return 1
	return value.get_unit_area() / empty_quantity.get_unit_area()

func get_empty_space():
	var empty_quantity = get_empty_quantity()
	if empty_quantity == null:
		return
	return empty_quantity.get_area()
