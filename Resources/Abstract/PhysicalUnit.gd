extends Resource


class_name PhysicalUnit

export(String) var group_name
export(String) var readable_name
export(Texture) var icon

export(Vector2) var size = Vector2(1.0, 1.0)
export(float) var mass
enum NumericalUnitSetting{ CONTINUOUS, DISCRETE }
export(NumericalUnitSetting) var numerical_unit

func _to_string():
	return group_name

func get_area():
	return size.x * size.y
