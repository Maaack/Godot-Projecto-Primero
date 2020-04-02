extends VBoxContainer


const EMPTY_GROUP_NAME = 'EMPTY'
var counter_scene = preload("res://Objects/Interface/Counter/Counter.tscn")
var counter_nodes = []

func display_inventory(container:Node2D):
	if container == null:
		return
	if not container.has_method('get_contents_array'):
		return
	var inventory_collection = sum_up_contents(container.get_contents_array())
	if inventory_collection != null and inventory_collection is PhysicalCollection:
		clear_counters()
		set_counters(inventory_collection.physical_quantities)

func set_counters(quantities_array:Array):
	for quantity in quantities_array:
		if not quantity is PhysicalQuantity:
			continue
		add_counter(quantity)

func sum_up_contents(quantities_array:Array):
	if quantities_array == null or quantities_array.size() == 0:
		return null
	var collection = PhysicalCollection.new()
	for quantity in quantities_array:
		if quantity.group_name != EMPTY_GROUP_NAME:
			collection.add_physical_quantity(quantity)
	return collection

func add_counter(quantity:PhysicalQuantity):
	var counter_instance = counter_scene.instance()
	add_child(counter_instance)
	counter_instance.quantity = quantity
	counter_nodes.append(counter_instance)

func clear_counters():
	for counter_node in counter_nodes:
		counter_node.queue_free()
	counter_nodes.clear()
