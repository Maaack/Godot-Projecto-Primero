extends Control


onready var texture_node = $MarginContainer/NinePatchRect/MarginContainer/TextureRect
onready var centered_node = $MarginContainer/NinePatchRect/CenterContainer/CenteredOverlay

var info_dialog_scene = preload("res://Objects/Interface/Window/RocketInspector/InfoDialog/InfoDialog.tscn")

func show_ship(ship_node:Node2D):
	reset_ship()
	texture_node.texture = ship_node.sprite.texture
	var ship_texture_size = ship_node.sprite.texture.get_size()
	var maximum_size = texture_node.rect_size
	var scale_ratio_vector = maximum_size / ship_texture_size
	var scale_ratio = min(scale_ratio_vector.x, scale_ratio_vector.y)
	show_ship_mounts(ship_node, scale_ratio)

func show_ship_mounts(ship_node:Node2D, scale_ratio:float):
	for mount in ship_node.get_children():
		if mount.is_in_group('MOUNT'):
			var icon_instance = info_dialog_scene.instance()
			centered_node.add_child(icon_instance)
			icon_instance.position = mount.position * scale_ratio
			var mounted_component = mount.mounted_system
			if mounted_component == null:
				continue
			icon_instance.physical_unit = mounted_component.physical_unit

func reset_ship():
	for current_node in centered_node.get_children():
		current_node.queue_free()
