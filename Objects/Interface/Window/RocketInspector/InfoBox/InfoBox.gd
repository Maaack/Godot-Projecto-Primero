extends Node2D


onready var name_node = $SmallWindow/MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/ScrollContainer/GridContainer/NameValue
onready var size_node = $SmallWindow/MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/ScrollContainer/GridContainer/SizeValue
onready var mass_node = $SmallWindow/MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/ScrollContainer/GridContainer/MassValue
onready var component_preview_node = $SmallWindow/MarginContainer/MarginContainer/HBoxContainer/ComponentPreview
onready var viewport_node = $SmallWindow/MarginContainer/MarginContainer/HBoxContainer/ComponentPreview/ViewportContainer/Viewport

var node_2d setget set_node_2d
var physical_unit setget set_physical_unit

signal inspect_button_pressed

func set_node_2d(local_node_2d:Node2D):
	node_2d = local_node_2d
	if node_2d == null:
		hide_preview()
		return
	show_preview(node_2d)
	if node_2d.physical_unit == null:
		return
	set_physical_unit(node_2d.physical_unit)

func show_preview(local_node_2d:Node2D):
	component_preview_node.show()
	viewport_node.add_child(local_node_2d)

func hide_preview():
	component_preview_node.hide()

func set_physical_unit(value:PhysicalUnit):
	if value == null:
		return
	physical_unit = value
	name_node.text = value.readable_name
	size_node.text = str(value.size)
	mass_node.text = str(value.mass)

func _on_InspectButton_pressed():
	emit_signal("inspect_button_pressed", node_2d, physical_unit)
