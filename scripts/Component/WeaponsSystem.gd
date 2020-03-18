extends "res://scripts/Component/Base/CyclingOutputSystem.gd"
	
	
export(NodePath) var initial_tracer_loader_path = null
enum FireGroupSettingEnum {ALL, CYCLE}
export(FireGroupSettingEnum) var fire_group_setting

onready var timer_trigger = $TimerTriggerMount
var tracer_loader_node = null
var is_triggered = false
onready var all_owner = get_parent()

func _ready():
	if initial_tracer_loader_path != null:
		tracer_loader_node = get_node(initial_tracer_loader_path)
		timer_trigger.set_output_nodes(tracer_loader_node)

func process(delta):
	process_weapon_triggers(delta)
	
func cycle_weapon():
	cycle_output_node()

func get_all_weapons():
	return get_output_nodes()

func get_current_weapon():
	return get_current_output_node()
	
func get_munitions_stored():
	var total_munitions = {}
	var weapons = get_all_weapons()
	for weapon in weapons:
		if weapon.has_method("get_munitions_stored"):
			var weapon_munitions = weapon.get_munitions_stored()
			for weapon_munition_type in weapon_munitions:
				if not total_munitions.has(weapon_munition_type):
					total_munitions[weapon_munition_type] = 0
				total_munitions[weapon_munition_type] += weapon_munitions[weapon_munition_type]
	return total_munitions

func process_weapon_triggers(delta):
	var weapons = get_all_weapons()
	if is_triggered:
		timer_trigger.process(delta)
		if fire_group_setting == FireGroupSettingEnum.ALL:
			for weapon in weapons:
				if weapon.has_method("trigger_on"):
					weapon.trigger_on()
		elif fire_group_setting == FireGroupSettingEnum.CYCLE:
			var weapon = get_current_weapon()
			if weapon != null and weapon.has_method("trigger_off"):
				weapon.trigger_on()
			cycle_weapon()
	else:
		for weapon in weapons:
			if weapon.has_method("trigger_off"):
				weapon.trigger_off()

func trigger_on():
	is_triggered = true

func trigger_off():
	is_triggered = false

