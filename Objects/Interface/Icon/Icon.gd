extends NinePatchRect


onready var texture_node = $Texture

export(Resource) var physical_unit setget set_physical_unit
export(Vector2) var texture_desired_size = Vector2(24.0, 24.0)


func set_physical_unit(value:PhysicalUnit):
	if value == null:
		return
	physical_unit = value
	set_icon(value.icon)

func set_icon(value:Texture):
	if value == null:
		return
	texture_node.texture = value
	var get_size = texture_node.texture.get_size()
	var scale_mod = texture_desired_size/get_size
	texture_node.rect_scale = scale_mod
