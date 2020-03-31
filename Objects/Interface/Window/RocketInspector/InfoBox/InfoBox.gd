extends Node2D


onready var name_node = $SmallWindow/MarginContainer/MarginContainer/ScrollContainer/GridContainer/NameValue
onready var size_node = $SmallWindow/MarginContainer/MarginContainer/ScrollContainer/GridContainer/SizeValue
onready var mass_node = $SmallWindow/MarginContainer/MarginContainer/ScrollContainer/GridContainer/MassValue

func set_physical_unit(value:PhysicalUnit):
	if value == null:
		return
	name_node.text = value.readable_name
	size_node.text = str(value.size)
	mass_node.text = str(value.mass)
