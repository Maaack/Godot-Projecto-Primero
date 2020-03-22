extends "res://scripts/Component/Base/CyclingOutputSystem.gd"


export var reload_rate_per_second = 1
export(Resource) var default_munition
export(Resource) var next_munition

var reload_time_delta = 0.0

func _ready():
	refresh_munition()
	
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

func set_next_munition(munition:Ownable):
	next_munition = munition
	return true

func unload_next_munition():
	var munition = unload_munition_type(next_munition)
	if munition != null:
		return munition
	return unload_default_munition()
	
func unload_default_munition():
	return unload_munition_type(default_munition)

func unload_munition_type(munition:Ownable):
	var contents = get_physical_owner().contents
	for collection in contents:
		if collection.physical_object == munition and collection.count > 0:
			collection.count -= 1
			return collection.physical_object
