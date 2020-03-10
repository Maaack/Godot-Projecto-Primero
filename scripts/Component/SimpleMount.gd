extends "res://scripts/WorldSpace/Node2D.gd"

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

func is_compatible(system:Node2D):
	return system.has_method("trigger_on") and system.has_method("trigger_off")

func mount(system:Node2D):
	if can_mount():
		add_child(system)
		mounted_system = system
		mounted_system.set_all_owner(get_physical_owner())
		
func unmount():
	if is_mounted():
		mounted_system = null

func trigger_on():
	if is_mounted() and mounted_system.has_method("trigger_on"):
		mounted_system.trigger_on()

func trigger_off():
	if is_mounted() and mounted_system.has_method("trigger_off"):
		mounted_system.trigger_off()

func process(delta):
	if is_mounted() and mounted_system.has_method("process"):
		mounted_system.process(delta)
	
func get_physical_owner():
	return get_parent().get_physical_owner()
