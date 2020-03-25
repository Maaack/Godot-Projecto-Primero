extends "res://Objects/WorldSpace/Ownable/RigidBody2D.gd"


onready var sprite = $Sprite

export(Resource) var destructable setget set_destructable
export var camera_scale = 1.0

var DestructableManager = preload("res://Objects/Managers/DestructableManager.gd")
var destructable_manager

func set_destructable(value:Destructable):
	if value == null:
		return
	destructable = value.duplicate()
	destructable_manager = DestructableManager.new(destructable)

func _physics_process(delta):
	if destructable == null or destructable_manager == null:
		return
	destructable_manager.physics_process(delta, self, sprite)
	if destructable_manager.destroyed == true:
		queue_free()
