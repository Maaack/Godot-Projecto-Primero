extends "res://Objects/WorldSpace/ObjectInSpace.gd"


onready var icon_node = $Sprite/Icon

export(Resource) var physical_quantity setget set_physical_quantity

var texture_desired_size = Vector2(24.0, 24.0)

func _ready():
	set_icon(physical_quantity.physical_unit)

func set_physical_quantity(value:PhysicalQuantity):
	if value == null:
		return
	physical_quantity = value

func set_icon(value:PhysicalUnit):
	if value == null:
		return
	icon_node.texture = value.icon
	var get_size = icon_node.texture.get_size()
	var scale_mod = texture_desired_size/get_size
	icon_node.scale = scale_mod

func collect():
	queue_free()
	return physical_quantity
