extends Resource


class_name SpecificContainer

export(Resource) var physical_collection setget set_physical_collection
export(String) var unit_key setget set_unit_key

func set_physical_collection(value:PhysicalCollection):
	if value == null:
		return
	physical_collection = value

func set_unit_key(value:String):
	if value == null:
		return
	unit_key = value
