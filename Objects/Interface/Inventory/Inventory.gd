extends VBoxContainer


const EMPTY_GROUP_NAME = 'EMPTY'

onready var grid_node = $GridContainer
onready var empty_value_node = $Header/EmptyValue

var button_scene = preload("res://Objects/Interface/Button/Button.tscn")
var physical_collection setget set_physical_collection
var empty_quantity setget set_empty_quantity

signal attention_on
signal attention_off
signal button_toggled

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
		button_instance.connect("attention_on", self, "_on_Button_attention_on")
		button_instance.connect("attention_off", self, "_on_Button_attention_off")
		button_instance.connect("button_toggled", self, "_on_Button_toggled")

func _on_Button_attention_on(physical_unit:PhysicalUnit):
	emit_signal("attention_on", physical_unit)

func _on_Button_attention_off(physical_unit:PhysicalUnit):
	emit_signal("attention_off", physical_unit)

func _on_Button_toggled(button_toggle, physical_unit:PhysicalUnit):
	emit_signal("button_toggled", button_toggle, physical_unit)

func clear_inventory():
	for child in grid_node.get_children():
		child.queue_free()
