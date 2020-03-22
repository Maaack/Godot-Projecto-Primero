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
	var total_munitions
	var weapons = get_all_weapons()
	for weapon in weapons:
		if weapon.has_method("get_munitions_stored"):
			if total_munitions == null:
				total_munitions = weapon.get_munitions_stored().duplicate()
			else:
				var munitions = weapon.get_munitions_stored()
				total_munitions = add_collections(total_munitions, munitions)
	return total_munitions
	
func add_collections(collections_1:Array, collections_2:Array):
	if collections_1 == null or collections_2 == null:
		return
	var collections = []
	for collection_1 in collections_1:
		if not collection_1 is Ownables:
			continue
		var collection = collection_1.duplicate()
		for collection_2 in collections_2:
			if not collection_2 is Ownables:
				continue
			if collection.group_name == collection_2.group_name:
				collection.count += collection_2.count
		collections.append(collection)
	return collections

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

