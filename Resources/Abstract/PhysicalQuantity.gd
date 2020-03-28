extends Resource


class_name PhysicalQuantity

export(Resource) var physical_unit

export(float) var quantity = 1.0 setget set_quantity


func _init(init_physical_unit=null, init_quantity=null):
	if init_physical_unit != null and init_physical_unit is PhysicalUnit:
		physical_unit = init_physical_unit
	if init_quantity != null:
		quantity = init_quantity

func set_quantity(value:float):
	if value == null:
		return
	quantity = value
	if physical_unit != null and physical_unit.numerical_unit == physical_unit.NumericalUnitSetting.DISCRETE:
		quantity = floor(quantity)

func get_unit_area():
	return physical_unit.get_area()

func get_mass():
	return quantity * physical_unit.mass

func get_area():
	return quantity * get_unit_area()
