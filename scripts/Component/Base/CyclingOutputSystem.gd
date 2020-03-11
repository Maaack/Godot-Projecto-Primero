extends "res://scripts/Component/Base/BasicOutputSystem.gd"


var current_output_node_index = 0

func get_current_output_node():
	var output_nodes_size = get_output_nodes().size()
	if output_nodes_size == 0 or current_output_node_index >= output_nodes_size:
		return null
	return output_nodes[current_output_node_index]
	
func cycle_output_node():
	current_output_node_index += 1
	reset_current_output_node()
	
func reset_current_output_node():
	if current_output_node_index >= get_output_nodes().size():
		current_output_node_index = 0
