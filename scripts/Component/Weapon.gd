extends "res://Objects/Ownable/Node2D.gd"


onready var trigger_system_mount = $TriggerOutputMount
onready var projectile_system_mount = $ProjectileSystemMount
onready var munitions_loading_system_mount = $MunitionsLoadingMount

func trigger_on():
	trigger_system_mount.trigger_on()
	
func trigger_off():
	trigger_system_mount.trigger_off()

func process(delta):
	trigger_system_mount.process(delta)
	projectile_system_mount.process(delta)
	munitions_loading_system_mount.process(delta)
	
func load_munition(munition):
	return munitions_loading_system_mount.load_munition(munition)
	
func set_next_munition(munition):
	return munitions_loading_system_mount.set_next_munition(munition)
