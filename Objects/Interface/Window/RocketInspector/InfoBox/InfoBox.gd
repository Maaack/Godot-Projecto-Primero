extends Node2D


onready var name_node = $SmallWindow/MarginContainer/MarginContainer/VBoxContainer/ScrollContainer/GridContainer/NameValue
onready var size_node = $SmallWindow/MarginContainer/MarginContainer/VBoxContainer/ScrollContainer/GridContainer/SizeValue
onready var mass_node = $SmallWindow/MarginContainer/MarginContainer/VBoxContainer/ScrollContainer/GridContainer/MassValue

var node_2d setget set_node_2d
var physical_unit setget set_physical_unit

signal inspect_button_pressed

func set_node_2d(value:Node2D):
	if value == null:
		return
	node_2d = value
	if node_2d.physical_unit == null:
		return
	set_physical_unit(node_2d.physical_unit)

func set_physical_unit(value:PhysicalUnit):
	if value == null:
		return
	physical_unit = value
	name_node.text = value.readable_name
	size_node.text = str(value.size)
	mass_node.text = str(value.mass)

func _on_InspectButton_pressed():
	if node_2d == null:
		return
	emit_signal("inspect_button_pressed", node_2d)
