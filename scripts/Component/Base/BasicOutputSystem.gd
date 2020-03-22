extends "res://Objects/Ownable/Node2D.gd"


enum OutputCountSettingEnum {LIMITED, UNLIMITED}
export(OutputCountSettingEnum) var output_count_setting
export(int) var max_output_count = 1
export(Array, NodePath) var initial_output_paths = []
var output_nodes = [] setget set_output_nodes, get_output_nodes

func _ready():
	for output_path in initial_output_paths:
		add_output_node(get_node(output_path))

func add_output_node(output_node:Node2D):
	if output_count_setting == OutputCountSettingEnum.LIMITED:
		if output_nodes.size() >= max_output_count:
			return
	if output_nodes.has(output_node):
		return
	output_nodes.append(output_node)

func remove_output_node(output_node:Node2D):
	if output_nodes.has(output_node):
		var index = output_nodes.find(output_node)
		output_nodes.remove(index)

func reset_output_nodes():
	var new_output_nodes= []
	for output_node in output_nodes:
		if is_instance_valid(output_node):
			new_output_nodes.append(output_node)
	output_nodes = new_output_nodes
	
func set_output_nodes(value):
	if typeof(value) == TYPE_ARRAY:
		output_nodes = value
	else:
		output_nodes = []
		output_nodes.append(value)

func get_output_nodes():
	return output_nodes
