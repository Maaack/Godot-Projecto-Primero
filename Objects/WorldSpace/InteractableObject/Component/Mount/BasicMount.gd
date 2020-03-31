extends "res://Objects/WorldSpace/InteractableObject/Node2D.gd"


export(Resource) var mounted_system setget set_mounted_system

func _ready():
	if not is_instance_valid(mounted_system) and is_node_mounted():
		mounted_system = get_child(0)
	
func is_node_mounted():
	return get_child_count() > 0

func is_mounted():
	return is_instance_valid(mounted_system)
	
func can_mount():
	return not is_mounted()

func mount(system:Node2D):
	if can_mount():
		add_child(system)
		mounted_system = system
		
func unmount():
	if is_mounted():
		for child in get_children():
			child.queue_free()
		mounted_system = null

func process(delta):
	if is_mounted() and mounted_system.has_method("process"):
		mounted_system.process(delta)

func get_contents():
	if is_mounted() and mounted_system.has_method("get_contents"):
		return mounted_system.get_contents()

func set_mounted_system(value:PackedScenesUnit):
	if value == null:
		return
	var component_instance = value.component_scene.instance()
	component_instance.physical_unit = value
	unmount()
	mount(component_instance)
	
