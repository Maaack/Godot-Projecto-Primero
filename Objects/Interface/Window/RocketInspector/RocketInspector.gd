extends Control


onready var texture_node = $MarginContainer/NinePatchRect/MarginContainer/TextureRect
onready var centered_node = $MarginContainer/NinePatchRect/MarginContainer/CenterContainer/CenteredOverlay

export(Color) var ship_color = Color(0.5, 0.5, 0.5)
var icon_scene = preload("res://Objects/Interface/Icon/FreePositionIcon.tscn")

func _input(event):
	if event.is_action_pressed("ui_inspect"):
		if visible:
			hide()
		else:
			show()

func show_ship(ship_node:Node2D):
	texture_node.texture = ship_node.sprite.texture
	texture_node.modulate = ship_color
	var ship_texture_size = ship_node.sprite.texture.get_size()
	var maximum_size = texture_node.rect_size
	var scale_ratio_vector = maximum_size / ship_texture_size
	var scale_ratio = min(scale_ratio_vector.x, scale_ratio_vector.y)
	show_ship_mounts(ship_node, scale_ratio)

func show_ship_mounts(ship_node:Node2D, scale_ratio:float):
	for mount in ship_node.get_children():
		if mount.is_in_group('MOUNT'):
			var icon_instance = icon_scene.instance()
			centered_node.add_child(icon_instance)
			icon_instance.position = mount.position * scale_ratio
