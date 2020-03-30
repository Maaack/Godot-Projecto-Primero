extends Control


onready var texture_node = $MarginContainer/NinePatchRect/MarginContainer/TextureRect
onready var centered_node = $MarginContainer/NinePatchRect/CenterContainer/CenteredOverlay

var info_dialog_scene = preload("res://Objects/Interface/Window/RocketInspector/InfoDialog/InfoDialog.tscn")
var system_resource = preload("res://Resources/Abstract/Units/Components/System.tres")
var engine_resource = preload("res://Resources/Abstract/Units/Components/Engines/BaseEngine.tres")
var projectile_weapon_resource = preload("res://Resources/Abstract/Units/Components/Weapons/ProjectileWeapon.tres")

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
			if mount.is_in_group('ENGINE'):
				icon_instance.physical_unit = engine_resource
			elif mount.is_in_group('PROJECTILE_WEAPON'):
				icon_instance.physical_unit = projectile_weapon_resource
			else:
				icon_instance.physical_unit = system_resource

func reset_ship():
	for current_node in centered_node.get_children():
		current_node.queue_free()
