extends HBoxContainer


export(Resource) var physical_collection setget set_collection, get_collection
export(String) var key
onready var counter_node = $Counter
onready var progress_node = $TextureProgress

func _process(delta):
	update_progress_bar()

func setup(setup_collection:PhysicalCollection, setup_key:String):
	set_collection(setup_collection)
	key = setup_key
	
func set_collection(collection:PhysicalCollection):
	if collection == null:
		return
	physical_collection = collection

func get_collection():
	return physical_collection

func update_progress_bar():
	if physical_collection == null or key == null:
		return
	var progress = physical_collection.get_quantity_by_key(key)
	if progress != null:
		set_progress_bar(round(progress))

func set_progress_bar(value):
	progress_node.value = value
	counter_node.set_counter(value)
	
