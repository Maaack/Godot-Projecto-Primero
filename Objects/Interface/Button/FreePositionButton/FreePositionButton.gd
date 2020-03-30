extends Node2D


onready var button_node = $Button

export(Resource) var physical_unit setget set_physical_unit


func set_physical_unit(value:PhysicalUnit):
	if value == null:
		return
	physical_unit = value
	button_node.physical_unit = value
