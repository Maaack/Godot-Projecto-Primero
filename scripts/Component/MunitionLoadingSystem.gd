extends "res://scripts/Component/Base/CyclingOutputSystem.gd"


const BASIC_ROUNDS_TYPE = "BULLETS"
const TRACER_ROUNDS_TYPE = "TRACERS"
export var default_munitions_stored = {
	BASIC_ROUNDS_TYPE: 400,
	TRACER_ROUNDS_TYPE: 80
}
export var reload_rate_per_second = 1
export var default_munition = {'type': BASIC_ROUNDS_TYPE}

export(Array, Resource) var munitions

var munitions_stored = null
var next_munition = null
var reload_time_delta = 0.0
onready var all_owner = get_parent()

func _ready():
	refresh_munition()
	munitions_stored = default_munitions_stored.duplicate()
	
func cycle_chamber():
	cycle_output_node()

func get_current_chamber():
	return get_current_output_node()
	
func refresh_munition():
	reload_time_delta = 0.0
	next_munition = default_munition
	
func process(delta):
	var chamber = get_current_chamber()
	if chamber != null:
		if chamber.has_method("is_empty") and chamber.is_empty():
			reload_time_delta += delta
		if reload_time_delta > (1.0 / reload_rate_per_second):
			if chamber.has_method("load_munition"):
				chamber.load_munition(unload_next_munition())
				refresh_munition()
				cycle_chamber()

func set_next_munition(settings_dict:Dictionary):
	next_munition = settings_dict
	return true

func unload_next_munition():
	if not next_munition.has('type'):
		return
	var munition_type = next_munition['type']
	if munitions_stored.has(munition_type) and munitions_stored[munition_type] > 0:
		munitions_stored[munition_type] -= 1
		return next_munition
	elif munitions_stored[BASIC_ROUNDS_TYPE] > 0:
		munitions_stored[BASIC_ROUNDS_TYPE] -= 1
		return {'type': TRACER_ROUNDS_TYPE}
	
func get_munitions_stored():
	return munitions_stored

