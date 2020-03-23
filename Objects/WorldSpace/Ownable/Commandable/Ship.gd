extends "res://Objects/WorldSpace/Ownable/Commandable/Commandable.gd"


const BASE_ORIENTATION = PI/2

export var camera_scale = 1.0
export(NodePath) var initial_engines_system_mount_path = null
export(Array, NodePath) var initial_engine_mount_paths = []
var engines_system_mount = null
var engine_mounts = []

func _ready():
	if initial_engines_system_mount_path != null:
		engines_system_mount = get_node(initial_engines_system_mount_path)
	for initial_engine_mount_path in initial_engine_mount_paths:
		if initial_engine_mount_path != null:
			engine_mounts.append(get_node(initial_engine_mount_path))

func _physics_process(delta):
	engines_system_mount.process(delta)

func _integrate_forces(state):
	for engine_mount in engine_mounts:
		engine_mount.integrate_forces(state)

func get_physical_owner():
	return self

func input(event):
	if is_instance_valid(engines_system_mount):
		if event.is_action_pressed("ui_up") and engines_system_mount.has_method("trigger_forward_on"):
			engines_system_mount.trigger_forward_on()
		elif event.is_action_released("ui_up") and engines_system_mount.has_method("trigger_forward_off"):
			engines_system_mount.trigger_forward_off()
		if event.is_action_pressed("ui_down") and engines_system_mount.has_method("trigger_reverse_on"):
			engines_system_mount.trigger_reverse_on()
		elif event.is_action_released("ui_down") and engines_system_mount.has_method("trigger_reverse_off"):
			engines_system_mount.trigger_reverse_off()
		if event.is_action_pressed("ui_right") and engines_system_mount.has_method("trigger_right_spin_on"):
			engines_system_mount.trigger_right_spin_on()
		elif event.is_action_released("ui_right") and engines_system_mount.has_method("trigger_right_spin_off"):
			engines_system_mount.trigger_right_spin_off()
		if event.is_action_pressed("ui_left") and engines_system_mount.has_method("trigger_left_spin_on"):
			engines_system_mount.trigger_left_spin_on()
		elif event.is_action_released("ui_left") and engines_system_mount.has_method("trigger_left_spin_off"):
			engines_system_mount.trigger_left_spin_off()
