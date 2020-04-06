extends Control


onready var texture_node = $TextureRect
onready var mounts_container_node = $CenterContainer/MountsContainer

var mount_button_scene = preload("res://Objects/Interface/Button/FreePositionButton/FreePositionButton.tscn")
var circuit_board_texture = preload("res://Assets/originals/interface/circuit_board.png")

signal attention_on
signal attention_off
signal button_toggled

func show_component(component_node:Node2D):
	clear_mounts()
	set_texture(component_node)
	var texture_scale_ratio = get_texture_scale()
	show_mounts(component_node, texture_scale_ratio)

func set_texture(component_node:Node2D):
	var texture = circuit_board_texture
	if component_node.sprite_node != null:
		texture = component_node.sprite_node.texture
	texture_node.texture = texture

func get_texture_scale():
	var texture_size = texture_node.texture.get_size()
	var maximum_size = texture_node.rect_size
	var scale_ratio_vector = maximum_size / texture_size
	var scale_ratio = min(scale_ratio_vector.x, scale_ratio_vector.y)
	return min(scale_ratio_vector.x, scale_ratio_vector.y)

func show_mounts(component_node:Node2D, scale_ratio:float):
	for mount in component_node.get_children():
		if mount.is_in_group('MOUNT'):
			var mount_button_instance = mount_button_scene.instance()
			mounts_container_node.add_child(mount_button_instance)
			mount_button_instance.position = mount.position * scale_ratio
			var mounted_component = mount.mounted_system
			if mounted_component == null:
				continue
			mount_button_instance.physical_unit = mounted_component.physical_unit
			mount_button_instance.connect("attention_on", self, "_on_FreePositionButton_attention_on")
			mount_button_instance.connect("attention_off", self, "_on_FreePositionButton_attention_off")
			mount_button_instance.connect("button_toggled", self, "_on_FreePositionButton_toggled")

func clear_mounts():
	for child in mounts_container_node.get_children():
		if is_instance_valid(child):
			child.queue_free()

func _on_FreePositionButton_attention_on(value:PhysicalUnit):
	emit_signal("attention_on", value)

func _on_FreePositionButton_attention_off(value:PhysicalUnit):
	emit_signal("attention_off", value)

func _on_FreePositionButton_toggled(button_toggle, physical_unit:PhysicalUnit):
	emit_signal("button_toggled", button_toggle, physical_unit)
