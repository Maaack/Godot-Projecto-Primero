extends "res://scripts/Component/Base/CyclingOutputSystem.gd"
	
	
const FIRE_GROUP_MODE_ALL = 0
const FIRE_GROUP_MODE_CYCLE = 1

onready var timer_trigger = $TimerTriggerMount

export(NodePath) var initial_tracer_loader_path = null
var tracer_loader_node = null
var fire_group_mode = FIRE_GROUP_MODE_ALL
var is_triggered = false
onready var all_owner = get_parent()

func _ready():
	if initial_tracer_loader_path != null:
		tracer_loader_node = get_node(initial_tracer_loader_path)
		timer_trigger.set_output_nodes(tracer_loader_node)

func process(delta):
	process_weapon_groups(delta)
	process_weapons(delta)
	
func cycle_weapon():
	cycle_output_node()

func get_all_weapons():
	return get_output_nodes()

func get_current_weapon():
	return get_current_output_node()

func process_weapon_groups(delta):
	var weapons = get_all_weapons()
	if is_triggered:
		timer_trigger.process(delta)
		if fire_group_mode == FIRE_GROUP_MODE_ALL:
			for weapon in weapons:
				if weapon.has_method("trigger_on"):
					weapon.trigger_on()
		elif fire_group_mode == FIRE_GROUP_MODE_CYCLE:
			var weapon = get_current_weapon()
			if weapon != null and weapon.has_method("trigger_off"):
				weapon.trigger_on()
			cycle_weapon()
	else:
		for weapon in weapons:
			if weapon.has_method("trigger_off"):
				weapon.trigger_off()

func process_weapons(delta):
	var weapons = get_all_weapons()
	for weapon in weapons:
		if weapon.has_method("process"):
			weapon.process(delta)

func trigger_on():
	is_triggered = true

func trigger_off():
	is_triggered = false

