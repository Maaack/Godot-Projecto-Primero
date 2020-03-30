extends TextureButton


onready var icon_node = $Icon

export(Resource) var physical_unit setget set_physical_unit


func set_physical_unit(value:PhysicalUnit):
	if value == null:
		return
	physical_unit = value
	icon_node.physical_unit = value
	icon_node.show()
