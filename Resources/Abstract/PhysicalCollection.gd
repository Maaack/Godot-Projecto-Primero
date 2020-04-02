extends PhysicalQuantities


class_name PhysicalCollection

const EMPTY_GROUP_NAME = 'EMPTY'

func _to_string():
	var to_string = "[Collection: ["
	for physical_quantity in physical_quantities:
		to_string += str(physical_quantity) + ","
	return to_string + "]]"

func get_empty_quantity_value():
	return get_quantity_value(EMPTY_GROUP_NAME)

func get_empty_quantity():
	return get_physical_quantity(EMPTY_GROUP_NAME)

func add_physical_collection(value:PhysicalCollection):
	return .add_physical_quantities(value)

func subtract_physical_collection(value:PhysicalCollection):
	if value == null:
		return
	var negative_value = value.get_negative()
	var negative_available_value = add_physical_collection(negative_value)
	return negative_available_value.get_negative()

func add_physical_quantity(value:PhysicalQuantity, ignore_empty=false):
	if value == null:
		return
	value = value.duplicate()
	var key = value.group_name
	if value.quantity > 0 and not ignore_empty:
		value.quantity = get_max_quantity_from_empty_space(value)
		if value.quantity == 0:
			print("No space for ", str(value))
	elif value.quantity < 0:
		var max_quantity = get_max_quantity_from_existing_quantity(key, value)
		if max_quantity == null:
			return
		value.quantity = max_quantity
		if value.quantity == 0:
			print("Not enough for ", str(value))
	if value.quantity == 0:
		return value
	var added_quantity = .add_physical_quantity(value)
	if not ignore_empty:
		fill_space(added_quantity)
	return added_quantity

func get_max_quantity_from_empty_space(value:PhysicalQuantity):
	var empty_quantity = get_empty_quantity()
	if empty_quantity == null:
		return value.quantity
	var quantity_empty = empty_quantity.get_quantity_for_area(value.get_area())
	var available_area = min(empty_quantity.get_area(), value.get_area())
	return value.get_quantity_for_area(available_area)

func get_max_quantity_from_existing_quantity(key, value:PhysicalQuantity):
	if not physical_quantities_dict.has(key):
		return
	var current_quantity = physical_quantities_dict[key]
	return max(-current_quantity.quantity, value.quantity)
		
func fill_space(value:PhysicalQuantity):
	if value == null:
		return
	var empty_quantity = get_empty_quantity()
	if empty_quantity == null:
		return
	empty_quantity = empty_quantity.duplicate()
	var quantity_empty = empty_quantity.get_quantity_for_area(value.get_area())
	empty_quantity.quantity = -quantity_empty
	return .add_physical_quantity(empty_quantity)

func get_empty_area():
	var empty_quantity = get_empty_quantity()
	if empty_quantity == null:
		return
	return empty_quantity.get_area()

func has_empty_space(value:float):
	var empty_area = get_empty_area()
	if empty_area == null:
		return true
	return empty_area > value
	
