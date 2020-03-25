extends "res://Objects/ThingsInSpace/BasicTarget/BasicTarget.gd"


onready var icon = $Sprite/Icon

export(Resource) var physical_quantity setget set_physical_quantity

func set_physical_quantity(value:PhysicalQuantity):
	physical_quantity = value.duplicate()
	icon.texture = physical_quantity.physical_unit.icon


