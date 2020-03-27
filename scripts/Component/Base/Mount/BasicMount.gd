extends "res://Objects/WorldSpace/Ownable/Node2D.gd"


var mounted_system = null

func _ready():
	reset_mounted_system()

func reset_mounted_system():
	if is_mounted():
		mounted_system = get_child(0)
	else:
		mounted_system = null
	
func is_mounted():
	return get_child_count() > 0
	
func can_mount():
	return not is_mounted()

func mount(system:Node2D):
	if can_mount():
		add_child(system)
		mounted_system = system
		
func unmount():
	if is_mounted():
		mounted_system = null

func process(delta):
	if is_mounted() and mounted_system.has_method("process"):
		mounted_system.process(delta)
