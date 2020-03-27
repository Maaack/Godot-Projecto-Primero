extends "res://scripts/Component/Base/Mount/BasicMount.gd"


export(Array, NodePath) var initial_forward_engine_paths = []
export(Array, NodePath) var initial_reverse_engine_paths = []
export(Array, NodePath) var initial_right_spin_engine_paths = []
export(Array, NodePath) var initial_left_spin_engine_paths = []
var forward_engine_nodes = []
var reverse_engine_nodes = []
var right_spin_engine_nodes = []
var left_spin_engine_nodes = []

var is_triggered = false
onready var all_owner = get_parent()

func _ready():
	for engine_path in initial_forward_engine_paths:
		var engine_node = get_node(engine_path)
		if is_instance_valid(engine_node):
			forward_engine_nodes.append(engine_node)
	for engine_path in initial_reverse_engine_paths:
		var engine_node = get_node(engine_path)
		if is_instance_valid(engine_node):
			reverse_engine_nodes.append(engine_node)
	for engine_path in initial_right_spin_engine_paths:
		var engine_node = get_node(engine_path)
		if is_instance_valid(engine_node):
			right_spin_engine_nodes.append(engine_node)
	for engine_path in initial_left_spin_engine_paths:
		var engine_node = get_node(engine_path)
		if is_instance_valid(engine_node):
			left_spin_engine_nodes.append(engine_node)
	link_mounted_outputs()

func link_mounted_outputs():
	if is_mounted():
		if mounted_system.has_method("set_forward_engines"):
			mounted_system.set_forward_engines(forward_engine_nodes)
		if mounted_system.has_method("set_reverse_engines"):
			mounted_system.set_reverse_engines(reverse_engine_nodes)
		if mounted_system.has_method("set_right_spin_engines"):
			mounted_system.set_right_spin_engines(right_spin_engine_nodes)
		if mounted_system.has_method("set_left_spin_engines"):
			mounted_system.set_left_spin_engines(left_spin_engine_nodes)

func process_engines(delta):
	if is_mounted() and mounted_system.has_method("process_engines"):
		return mounted_system.process_engines(delta)

func set_forward_engines(engines):
	if is_mounted() and mounted_system.has_method("set_forward_engines"):
		return mounted_system.set_forward_engines(engines)

func set_reverse_engines(engines):
	if is_mounted() and mounted_system.has_method("set_reverse_engines"):
		return mounted_system.set_reverse_engines(engines)

func set_right_spin_engines(engines):
	if is_mounted() and mounted_system.has_method("set_right_spin_engines"):
		return mounted_system.set_right_spin_engines(engines)

func set_left_spin_engines(engines):
	if is_mounted() and mounted_system.has_method("set_left_spin_engines"):
		return mounted_system.set_left_spin_engines(engines)

func trigger_forward_on():
	if is_mounted() and mounted_system.has_method("trigger_forward_on"):
		return mounted_system.trigger_forward_on()

func trigger_forward_off():
	if is_mounted() and mounted_system.has_method("trigger_forward_off"):
		return mounted_system.trigger_forward_off()
		
func trigger_reverse_on():
	if is_mounted() and mounted_system.has_method("trigger_reverse_on"):
		return mounted_system.trigger_reverse_on()
		
func trigger_reverse_off():
	if is_mounted() and mounted_system.has_method("trigger_reverse_off"):
		return mounted_system.trigger_reverse_off()
		
func trigger_right_spin_on():
	if is_mounted() and mounted_system.has_method("trigger_right_spin_on"):
		return mounted_system.trigger_right_spin_on()
		
func trigger_right_spin_off():
	if is_mounted() and mounted_system.has_method("trigger_right_spin_off"):
		return mounted_system.trigger_right_spin_off()

func trigger_left_spin_on():
	if is_mounted() and mounted_system.has_method("trigger_left_spin_on"):
		return mounted_system.trigger_left_spin_on()

func trigger_left_spin_off():
	if is_mounted() and mounted_system.has_method("trigger_left_spin_off"):
		return mounted_system.trigger_left_spin_off()
