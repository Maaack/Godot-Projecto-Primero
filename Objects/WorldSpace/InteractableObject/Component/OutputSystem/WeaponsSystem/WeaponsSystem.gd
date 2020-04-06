extends "res://Objects/WorldSpace/InteractableObject/Component/OutputSystem/CyclingOutputSystem.gd"
	
	
enum FireGroupSettingEnum {ALL, CYCLE}
export(FireGroupSettingEnum) var fire_group_setting

onready var timer_trigger = $TimerTriggerMount
var is_triggered = false
onready var all_owner = get_parent()

func post_set_output_nodes(value):
	for output_node in output_nodes:
		if output_node.is_in_group('TRACER_LOADER'):
			timer_trigger.set_output_nodes([output_node])

func process(delta):
	process_weapon_triggers(delta)
	
func cycle_weapon():
	cycle_output_node()

func get_all_weapons():
	var weapons = []
	for node in output_nodes:
		if node.is_in_group('WEAPON'):
			weapons.append(node)
	return weapons

func get_current_weapon():
	return get_current_output_node()

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

