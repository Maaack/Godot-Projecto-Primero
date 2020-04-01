extends "res://Objects/WorldSpace/InteractableObject/Component/OutputSystem/CyclingOutputSystem.gd"


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
	if chamber == null:
		return
	if not chamber.has_method("is_empty") or not chamber.is_empty():
		return
	reload_time_delta += delta
	if reload_time_delta < (1.0 / reload_rate_per_second):
		return
	if not chamber.has_method("load_munitions"):
		return
	chamber.load_munitions(unload_next_munition())
	refresh_munition()
	cycle_chamber()

func set_next_munition(munition:PackedScenesUnit):
	if munition == null:
		return
	next_munition = munition
	return true

func unload_next_munition():
	var munition = unload_munition_type(next_munition)
	if munition != null:
		return munition
	return unload_default_munition()
	
func unload_default_munition():
	return unload_munition_type(default_munition)

func unload_munition_type(munition:PackedScenesUnit, amount=1.0):
	var contents = get_physical_owner().contents
	if contents == null:
		return
	var quantity = contents.get_physical_quantity(munition.group_name)
	if quantity == null or quantity.quantity < amount:
		return
	var bullets_to_load = PhysicalQuantity.new(munition, -amount)
	var bullets_loaded = contents.add_physical_quantity(bullets_to_load)
	if bullets_loaded == null:
		return
	bullets_loaded.quantity = -(bullets_loaded.quantity)
	return bullets_loaded
