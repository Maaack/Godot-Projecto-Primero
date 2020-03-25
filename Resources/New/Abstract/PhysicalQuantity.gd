extends Resource


class_name PhysicalQuantity

export(Resource) var physical_unit

export(float) var quantity = 1.0


func _init(init_physical_unit=null, init_quantity=null):
	if init_physical_unit != null and init_physical_unit is PhysicalUnit:
		physical_unit = init_physical_unit
	if init_quantity != null:
		quantity = init_quantity
