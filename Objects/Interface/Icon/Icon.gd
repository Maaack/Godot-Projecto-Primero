extends NinePatchRect


onready var texture_node = $Texture

export var texture_desired_size = Vector2(24.0, 24.0)

func set_icon(value:Texture):
	if value == null:
		return
	texture_node.texture = value
	var get_size = texture_node.texture.get_size()
	var scale_mod = texture_desired_size/get_size
	texture_node.rect_scale = scale_mod
