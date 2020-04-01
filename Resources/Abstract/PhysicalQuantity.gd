extends Resource


class_name PhysicalQuantity

export(Resource) var physical_unit

export(float) var quantity = 1.0 setget set_quantity


func _init(init_physical_unit=null, init_quantity=null):
	if init_physical_unit != null and init_physical_unit is PhysicalUnit:
		physical_unit = init_physical_unit
	if init_quantity != null:
		quantity = init_quantity

func _to_string():
	return "[Quantity: [" + str(physical_unit) + ", " + str(quantity) + "]]"

func set_quantity(value:float):
	if value == null:
		return
	quantity = value
	if physical_unit != null and physical_unit.numerical_unit == physical_unit.NumericalUnitSetting.DISCRETE:
		quantity = floor(quantity)

func add_quantity(value:float):
	if value == null or value == 0.0:
		return
	set_quantity(quantity + value)

func add_physical_quantity(value:PhysicalQuantity):
	if value == null:
		return
	if value.get_group_name() != get_group_name():
		print("Error: Adding incompatible quantities ", str(value), " and ", str(self))
		return
	add_quantity(value.quantity)	

func get_unit_area():
	return physical_unit.get_area()

func get_mass():
	return quantity * physical_unit.mass

func get_area():
	return quantity * get_unit_area()

func get_group_name():
	if physical_unit == null:
		return
	return physical_unit.group_name

func get_readable_name():
	if physical_unit == null:
		return
	return physical_unit.readable_name

func get_world_space_scene():
	if physical_unit == null:
		return
	return physical_unit.world_space_scene

func get_component_scene():
	if physical_unit == null:
		return
	return physical_unit.component_scene

func get_quantity_for_area(value:float):
	var unit_area = get_unit_area()
	return value / unit_area
