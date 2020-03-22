extends NinePatchRect


export(Resource) var collection setget set_collection, get_collection
onready var label_node = $Label
onready var texture_node = $Texture

func _process(delta):
	update_counter()

func set_collection(ownables:Ownables):
	if ownables == null:
		return
	collection = ownables
	texture_node.texture = ownables.icon
	label_node.set_text(str(collection.count))

func get_collection():
	return collection

func update_counter():
	if collection == null:
		return
	label_node.set_text(str(collection.count))

func set_counter(value):
	label_node.set_text(str(value))
	
