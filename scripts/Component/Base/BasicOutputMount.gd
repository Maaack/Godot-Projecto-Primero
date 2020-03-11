extends "res://scripts/Component/Base/BasicMount.gd"


export(Array, NodePath) var initial_output_mounts = []
var output_mounts = []


func _ready():
	for output_path in initial_output_mounts:
		var output_mount_node = get_node(output_path)
		if is_instance_valid(output_mount_node):
			output_mounts.append(output_mount_node)
	link_mounted_outputs()

func link_mounted_outputs():
	if is_mounted() and mounted_system.has_method("set_output_nodes"):
		mounted_system.set_output_nodes(output_mounts)

func add_output_node(output_node:Node2D):
	if is_mounted() and mounted_system.has_method("add_output_node"):
		mounted_system.add_output_node(output_node)

func remove_output_node(output_node:Node2D):
	if is_mounted() and mounted_system.has_method("remove_output_node"):
		mounted_system.remove_output_node(output_node)

func reset_output_nodes():
	if is_mounted() and mounted_system.has_method("reset_output_nodes"):
		mounted_system.reset_output_nodes()
	
func set_output_nodes(value):
	if is_mounted() and mounted_system.has_method("set_output_nodes"):
		mounted_system.set_output_nodes(value)

func get_output_nodes():
	if is_mounted() and mounted_system.has_method("get_output_nodes"):
		return mounted_system.get_output_nodes()
