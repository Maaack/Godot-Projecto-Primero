extends "res://scripts/Component/Base/CyclingOutputSystem.gd"


export var custom_munition = {}

export(Array, NodePath) var initial_munition_loader_paths = []
var munition_loaders = []
var next_munition_loader_index = 0
onready var all_owner = get_parent()

func _ready():
	for munition_loader_path in initial_munition_loader_paths:
		var munition_loader = get_node(munition_loader_path)
		add_munition_loader(munition_loader)
		
func cycle_munition_loader():
	next_munition_loader_index = (next_munition_loader_index + 1) % munition_loaders.size()
	
func trigger_on():
	var munition_loader = get_next_munition_loader()
	if munition_loader != null and munition_loader.has_method("load_munition"):
		munition_loader.load_munition(custom_munition)

func get_physical_owner():
	var parent = get_parent()
	if parent.has_method("get_physical_owner"):
		return get_parent().get_physical_owner()
	else:
		return self

func add_munition_loader(munition_loader:Node2D):
	if not munition_loaders.has(munition_loader):
		munition_loaders.append(munition_loader)
	
func remove_munition_loader(munition_loader:Node2D):
	if munition_loaders.has(munition_loader):
		var index = munition_loaders.find(munition_loader)
		munition_loaders.remove(index)
		
func get_next_munition_loader():
	if munition_loaders.size() > 0:
		cycle_munition_loader()
		return munition_loaders[next_munition_loader_index]
	return null

func reset_munition_loaders():
	var new_munition_loaders = []
	for munition_loader in munition_loaders:
		if is_instance_valid(munition_loader):
			new_munition_loaders.append(munition_loader)
	munition_loaders = new_munition_loaders
	if next_munition_loader_index > munition_loaders.size():
		next_munition_loader_index = 0
