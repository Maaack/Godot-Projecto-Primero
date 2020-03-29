extends Resource


class_name PhysicalQuantities

export(Array, Resource) var physical_quantities setget set_physical_quantities

var physical_quantities_dict = {}

func _init(init_physical_quantities=null):
	if init_physical_quantities != null:
		set_physical_quantities(init_physical_quantities)

func _to_string():
	var to_string = "[Quantities: ["
	for physical_quantity in physical_quantities:
		to_string += str(physical_quantity) + ","
	return to_string + "]]"

func set_physical_quantities(value:Array):
	if value == null:
		return
	physical_quantities = []
	for physical_quantity in value:
		physical_quantities.append(physical_quantity.duplicate())
	reset_key_map()

func _append_physical_quantity(value:PhysicalQuantity):
	if value == null:
		return
	var key = value.get_group_name()
	if key == null:
		return
	physical_quantities.append(value)
	physical_quantities_dict[key] = value
	return value

func add_physical_quantity(value:PhysicalQuantity):
	if value == null:
		return null
	var key = value.get_group_name()
	if key == null:
		return
	if physical_quantities_dict.has(key):
		var existing_quantity = physical_quantities_dict[key]
		existing_quantity.add_physical_quantity(value)
	else:
		return _append_physical_quantity(value)
	return value

func set_physical_quantity(value:PhysicalQuantity):
	if value == null:
		return null
	var key = value.get_group_name()
	if key == null:
		return
	if physical_quantities.has(key):	
		physical_quantities_dict[key].quantity = value.quantity
	else:
		return _append_physical_quantity(value)
	return value

func add_physical_quantities(value:PhysicalQuantities):
	if value == null:
		return
	var added_quantities = duplicate()
	added_quantities.clear()
	for physical_quantity in value.physical_quantities:
		var added_quantity = add_physical_quantity(physical_quantity)
		if added_quantity != null:
			added_quantities._append_physical_quantity(added_quantity)
	return added_quantities

func subtract_physical_quantities(value:PhysicalQuantities):
	if value == null:
		return
	var negative_quantities = value.get_negative()
	var subtracted_negative_quantities = add_physical_quantities(negative_quantities)
	var subtracted_quantities = subtracted_negative_quantities.get_negative()
	return subtracted_quantities

func clear():
	physical_quantities_dict.clear()
	physical_quantities.clear()

func reset_key_map():
	physical_quantities_dict.clear()
	for physical_quantity in physical_quantities:
		var key = physical_quantity.get_group_name()
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

func get_sum_quantity():
	var sum_quantity = 0.0
	if physical_quantities == null:
		return sum_quantity
	for physical_quantity in physical_quantities:
		if physical_quantity is PhysicalQuantity:
			sum_quantity += physical_quantity.quantity
	return sum_quantity

func get_mass():
	var sum_mass = 0.0
	if physical_quantities == null:
		return sum_mass
	for physical_quantity in physical_quantities:
		if physical_quantity is PhysicalQuantity:
			sum_mass += physical_quantity.get_mass()
	return sum_mass

func get_area():
	var sum_area = 0.0
	if physical_quantities == null:
		return sum_area
	for physical_quantity in physical_quantities:
		if physical_quantity is PhysicalQuantity:
			sum_area += physical_quantity.get_area()
	return sum_area

func get_negative():
	var negative_quantities = duplicate()
	negative_quantities.clear()
	for physical_quantity in physical_quantities:
		var negative_quantity = physical_quantity.duplicate()
		negative_quantity.quantity = -(negative_quantity.quantity)
		negative_quantities._append_physical_quantity(negative_quantity)
	return negative_quantities
