extends Control


onready var info_box_container_node = $MarginContainer/MarginContainer/InfoBoxContainer
onready var inventory_node = $MarginContainer/MarginContainer/HBoxContainer/Inventory
onready var component_insepctor_node = $MarginContainer/MarginContainer/HBoxContainer/ComponentInspector

export(Vector2) var default_info_box_offset = Vector2(0.0, 60.0)

var unit_component_map = {}

func show_ship(ship_node:Node2D):
	component_insepctor_node.show_component(ship_node)
	var ship_contents = ship_node.get_physical_owner().contents
	inventory_node.physical_collection = ship_contents

func show_info_box(physical_unit:PhysicalUnit):
	var box_position = get_local_mouse_position() + default_info_box_offset
	info_box_container_node.show_info_box(physical_unit, box_position)

func hide_info_box(physical_unit:PhysicalUnit):
	info_box_container_node.hide_info_box(physical_unit)

func inspect_toggled(button_pressed:bool, physical_unit:PhysicalUnit):
	var node_2d
	if not is_instance_valid(physical_unit):
		return
	if unit_component_map.has(physical_unit):
		node_2d = unit_component_map[physical_unit]
	else:
		if not physical_unit is PackedScenesUnit or physical_unit.component_scene == null:
			return
		node_2d = physical_unit.component_scene.instance()
		node_2d.set_physical_unit(physical_unit, false)
	unit_component_map[physical_unit] = node_2d
	if button_pressed:
		info_box_container_node.show_preview(node_2d)
	else:
		info_box_container_node.hide_preview(node_2d)

func _on_ComponentInspector_attention_on(physical_unit:PhysicalUnit):
	show_info_box(physical_unit)

func _on_ComponentInspector_attention_off(physical_unit:PhysicalUnit):
	hide_info_box(physical_unit)

func _on_ComponentInspector_button_toggled(button_pressed:bool, physical_unit:PhysicalUnit):
	inspect_toggled(button_pressed, physical_unit)

func _on_Inventory_attention_on(physical_unit:PhysicalUnit):
	show_info_box(physical_unit)

func _on_Inventory_attention_off(physical_unit:PhysicalUnit):
	hide_info_box(physical_unit)

func _on_Inventory_button_toggled(button_pressed:bool, physical_unit:PhysicalUnit):
	inspect_toggled(button_pressed, physical_unit)

func _on_InfoBoxContainer_inspect_button_pressed(node_2d:Node2D, physical_unit:PhysicalUnit):
	component_insepctor_node.show_component(node_2d)


