extends VBoxContainer


const EMPTY_GROUP_NAME = 'EMPTY'

onready var grid_node = $GridContainer
onready var empty_value_node = $Header/EmptyValue

export(Vector2) var default_info_box_offset = Vector2(0.0, 60.0)

var button_scene = preload("res://Objects/Interface/Button/Button.tscn")
var info_box_scene = preload("res://Objects/Interface/Window/RocketInspector/InfoBox/InfoBox.tscn")
var physical_collection setget set_physical_collection
var empty_quantity setget set_empty_quantity

var button_info_box_map = {}

func set_physical_collection(value:PhysicalCollection):
	if value == null:
		return
	physical_collection = value
	update_inventory()

func set_empty_quantity(value:PhysicalQuantity):
	if value == null:
		return
	empty_quantity = value
	empty_value_node.text = str(value.quantity) + " M^2"

func update_inventory():
	clear_inventory()
	if physical_collection == null:
		return
	for physical_quantity in physical_collection.physical_quantities:
		if physical_quantity.group_name == EMPTY_GROUP_NAME:
			set_empty_quantity(physical_quantity)
			continue
		var button_instance = button_scene.instance()
		button_instance.physical_unit = physical_quantity
		grid_node.add_child(button_instance)
		button_instance.connect("attention_on", self, "attach_info_box")

func attach_info_box(value:Node):
	if button_info_box_map.has(value):
		return button_info_box_map[value]
	var info_box_instance = info_box_scene.instance()
	value.connect("attention_off", self, "detach_info_box")
	add_child(info_box_instance)
	button_info_box_map[value] = info_box_instance
	info_box_instance.show()
	info_box_instance.physical_unit = value.physical_unit
	var info_box_position = get_local_mouse_position()
	info_box_instance.position = info_box_position + default_info_box_offset
	return info_box_instance

func detach_info_box(value:Node):
	if button_info_box_map.has(value):
		var info_box_node = button_info_box_map[value]
		if not is_instance_valid(info_box_node):
			return
		info_box_node.queue_free()
		button_info_box_map.erase(value)

func clear_inventory():
	for child in grid_node.get_children():
		child.queue_free()

func _on_Button_positioned(value):
	attach_info_box(value)
