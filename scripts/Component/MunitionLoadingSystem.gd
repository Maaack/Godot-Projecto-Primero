extends "res://scripts/Component/Base/CyclingOutputSystem.gd"


export var reload_rate_per_second = 8
export var default_munition = {}

var next_munition = null
var reload_time_delta = 0.0
onready var all_owner = get_parent()

func _ready():
	cycle_rounds()
		
func cycle_chamber():
	cycle_output_node()

func get_current_chamber():
	return get_current_output_node()
	
func cycle_rounds():
	reload_time_delta = 0.0
	next_munition = default_munition
	
func process(delta):
	reload_time_delta += delta
	if reload_time_delta > (1.0 / reload_rate_per_second):
		var chamber = get_current_chamber()
		if chamber != null and chamber.has_method("load_munition"):
			var loaded = chamber.load_munition(next_munition)
			if loaded:
				cycle_rounds()
				cycle_chamber()

func load_munition(settings_dict:Dictionary):
	next_munition = settings_dict
	return true
