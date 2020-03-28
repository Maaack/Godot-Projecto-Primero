extends HBoxContainer


export(Resource) var collection setget set_collection
export(String) var unit_key setget set_unit_key
onready var counter_node = $Counter
onready var progress_node = $TextureProgress

func _process(delta):
	update_progress_bar()

func set_all(physical_collection:PhysicalCollection, key:String):
	set_collection(physical_collection)
	set_unit_key(key)
	
func set_collection(value:PhysicalCollection):
	if value == null:
		return
	collection = value
	set_counters()

func set_unit_key(value:String):
	if value == null:
		return
	unit_key = value
	set_counters()
	
func set_counters():
	if collection == null or unit_key == null:
		return
	progress_node.max_value = collection.get_sum_quantity()
	counter_node.quantity = collection.get_physical_quantity(unit_key)

func update_progress_bar():
	if collection == null or unit_key == null:
		return
	var progress = collection.get_quantity_value(unit_key)
	if progress != null:
		set_progress_bar(round(progress))

func set_progress_bar(value):
	progress_node.value = value
	
