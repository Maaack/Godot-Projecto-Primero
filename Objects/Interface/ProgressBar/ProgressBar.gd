extends HBoxContainer

onready var counter_node = $Counter
onready var progress_node = $TextureProgress

export(Resource) var specific_container setget set_specific_container
var physical_collection setget set_physical_collection

func _process(delta):
	update_progress_bar()

func set_specific_container(value:SpecificContainer):
	if value == null:
		return
	specific_container = value
	physical_collection = specific_container.physical_collection
	set_counters()
	
func set_physical_collection(value:PhysicalCollection):
	if value == null:
		return
	physical_collection = value
	set_counters()

func set_counters():
	if physical_collection == null or specific_container == null:
		return
	progress_node.max_value = physical_collection.get_sum_quantity()
	counter_node.quantity = specific_container.get_specific_quantity()

func update_progress_bar():
	if physical_collection == null or specific_container == null:
		return
	var progress = specific_container.get_specific_quantity().quantity
	if progress != null:
		set_progress_bar(round(progress))

func set_progress_bar(value):
	progress_node.value = value
	
