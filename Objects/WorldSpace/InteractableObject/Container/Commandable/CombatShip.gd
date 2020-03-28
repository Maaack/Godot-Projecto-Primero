extends "res://Objects/WorldSpace/InteractableObject/Container/Commandable/Ship.gd"


export(NodePath) var initial_weapons_system_mount_path = null
export(Array, NodePath) var initial_weapon_mount_paths = []
var weapons_system_mount = null
var weapon_mounts = []
var tracer_list = []

func _ready():
	if initial_weapons_system_mount_path != null:
		weapons_system_mount = get_node(initial_weapons_system_mount_path)
	for initial_weapon_mount_path in initial_weapon_mount_paths:
		if initial_weapon_mount_path != null:
			weapon_mounts.append(get_node(initial_weapon_mount_path))

func _physics_process(delta):
	weapons_system_mount.process(delta)
	for weapon_mount in weapon_mounts:
		weapon_mount.process(delta)

func input(event):
	.input(event)
	if is_instance_valid(weapons_system_mount):
		if event.is_action_pressed("ui_select") and weapons_system_mount.has_method("trigger_on"):
			weapons_system_mount.trigger_on()
		elif event.is_action_released("ui_select") and weapons_system_mount.has_method("trigger_off"):
			weapons_system_mount.trigger_off()

func get_tracer_list():
	refresh_tracer_list()
	return tracer_list

func refresh_tracer_list():
	var new_tracer_list = []
	for tracer in tracer_list:
		if is_instance_valid(tracer):
			new_tracer_list.append(tracer)
	tracer_list = new_tracer_list

func get_contents_array():
	var contents_array = .get_contents_array()
	for weapon_mount in weapon_mounts:
		var weapon_contents = weapon_mount.get_contents()
		if weapon_contents != null:
			contents_array += weapon_contents.physical_quantities
	return contents_array
