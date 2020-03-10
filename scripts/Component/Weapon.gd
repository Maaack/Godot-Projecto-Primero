extends "res://scripts/WorldSpace/Node2D.gd"


onready var trigger_system_mount = $TriggerSystemMount
onready var projectile_system_mount = $ProjectileSystemMount

func trigger_on():
	trigger_system_mount.trigger_on()
	
func trigger_off():
	trigger_system_mount.trigger_off()

func process(delta):
	trigger_system_mount.process(delta)
	projectile_system_mount.process(delta)
	
func get_physical_owner():
	return get_parent().get_physical_owner()
