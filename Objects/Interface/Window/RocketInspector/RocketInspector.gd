extends Control


onready var texture_node = $MarginContainer/MarginContainer/HBoxContainer/Container/TextureRect
onready var mounts_container_node = $MarginContainer/MarginContainer/HBoxContainer/Container/CenterContainer/MountsContainer
onready var info_box_container_node = $MarginContainer/MarginContainer/HBoxContainer/Container/CenterContainer/InfoBoxContainer
onready var inventory_node = $MarginContainer/MarginContainer/HBoxContainer/Inventory

export(Vector2) var default_info_box_offset = Vector2(0.0, 60.0)

var mount_button_scene = preload("res://Objects/Interface/Button/FreePositionButton/FreePositionButton.tscn")
var info_box_scene = preload("res://Objects/Interface/Window/RocketInspector/InfoBox/InfoBox.tscn")
var circuit_board_texture = preload("res://Assets/originals/interface/circuit_board.png")

func show_ship(ship_node:Node2D):
	reset_ship()
	var texture = circuit_board_texture
	if ship_node.sprite_node != null:
		texture = ship_node.sprite_node.texture
	texture_node.texture = texture
	var ship_texture_size = texture.get_size()
	var maximum_size = texture_node.rect_size
	var scale_ratio_vector = maximum_size / ship_texture_size
	var scale_ratio = min(scale_ratio_vector.x, scale_ratio_vector.y)
	var ship_contents = ship_node.get_physical_owner().contents
	inventory_node.physical_collection = ship_contents
	show_ship_mounts(ship_node, scale_ratio)

func show_ship_mounts(ship_node:Node2D, scale_ratio:float):
	for mount in ship_node.get_children():
		if mount.is_in_group('MOUNT'):
			var mount_button_instance = mount_button_scene.instance()
			mounts_container_node.add_child(mount_button_instance)
			mount_button_instance.position = mount.position * scale_ratio
			var mounted_component = mount.mounted_system
			if mounted_component == null:
				continue
			mount_button_instance.physical_unit = mounted_component.physical_unit
			var info_box_instance = info_box_scene.instance()
			info_box_container_node.add_child(info_box_instance)
			info_box_instance.node_2d = mounted_component
			var info_box_position = mount.position * scale_ratio
			info_box_instance.position = info_box_position + default_info_box_offset
			mount_button_instance.connect("mouse_entered", info_box_instance, "show")
			mount_button_instance.connect("mouse_exited", info_box_instance, "hide")
			info_box_instance.connect("inspect_button_pressed", self, "show_ship")

func reset_ship():
	for current_node in mounts_container_node.get_children():
		current_node.queue_free()
	for current_node in info_box_container_node.get_children():
		current_node.queue_free()
