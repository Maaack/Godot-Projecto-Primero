extends Container


var info_box_scene = preload("res://Objects/Interface/Window/RocketInspector/InfoBox/InfoBox.tscn")
var unit_info_box_map = {}

signal inspect_button_pressed

func show_info_box(physical_unit:PhysicalUnit, position:Vector2):
	if physical_unit == null or position == null:
		return
	var info_box_instance
	if unit_info_box_map.has(physical_unit):
		info_box_instance = unit_info_box_map[physical_unit]
	else:
		info_box_instance = _add_new_info_box(physical_unit)
	info_box_instance.position = position
	info_box_instance.show()
	return info_box_instance

func show_preview(node_2d:Node2D):
	if node_2d == null:
		return
	if node_2d.physical_unit == null:
		return
	if not unit_info_box_map.has(node_2d.physical_unit):
		return
	var info_box_instance = unit_info_box_map[node_2d.physical_unit]
	info_box_instance.node_2d = node_2d

func hide_preview(node_2d:Node2D):
	if node_2d == null:
		return
	if node_2d.physical_unit == null:
		return
	if not unit_info_box_map.has(node_2d.physical_unit):
		return
	var info_box_instance = unit_info_box_map[node_2d.physical_unit]
	info_box_instance.node_2d = null

func _add_new_info_box(physical_unit:PhysicalUnit):
	var info_box_instance = info_box_scene.instance()
	add_child(info_box_instance)
	unit_info_box_map[physical_unit] = info_box_instance
	info_box_instance.physical_unit = physical_unit
	info_box_instance.connect("inspect_button_pressed", self, "_on_InfoBox_inspect_button_pressed")
	return info_box_instance

func hide_info_box(physical_unit:PhysicalUnit):
	if not unit_info_box_map.has(physical_unit):
		return
	var info_box_node = unit_info_box_map[physical_unit]
	if not is_instance_valid(info_box_node):
		return
	info_box_node.hide()
	return info_box_node

func hide_all():
	for child in get_children():
		if is_instance_valid(child):
			child.hide()

func show_all():
	for child in get_children():
		if is_instance_valid(child):
			child.show()

func clear_all():
	for child in get_children():
		if is_instance_valid(child):
			child.queue_free()

func _on_InfoBox_inspect_button_pressed(node_2d:Node2D, physical_unit:PhysicalUnit):
	print("_on_InfoBox_inspect_button_pressed  ", node_2d, physical_unit)
	emit_signal("inspect_button_pressed", node_2d, physical_unit)
