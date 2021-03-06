extends "res://Objects/WorldSpace/RigidBody2D.gd"


const GRAVITY_CONST = 9.8
onready var sprite_node = $Sprite

export(Resource) var destructable setget set_destructable
export var camera_scale = 1.0

var DestructableManager = preload("res://Objects/Managers/DestructableManager.gd")
var destructable_manager
var destroyed = false
var last_linear_velocity
var legal_owner = null setget set_legal_owner, get_legal_owner
var collision_sound

signal destroyed

func set_destructable(value:Destructable):
	if value == null:
		return
	destructable = value.duplicate()
	destructable.duplicate_contents()
	destructable_manager = DestructableManager.new(destructable)

func destroy_self():
	if not destroyed:
		destroyed = true
		queue_free()
		emit_signal("destroyed", self)

func _ready():
	weight = mass * GRAVITY_CONST * gravity_scale

func _physics_process(delta):
	if destructable != null and destructable_manager != null and not destroyed:
		destructable_manager.physics_process(delta, self, sprite_node)
		var now_destroyed = destructable_manager.destroyed
		if now_destroyed:
			destroy_self()
	last_linear_velocity = linear_velocity

func get_legal_owner():
	var parent = get_parent()
	if parent != null and parent.has_method("get_legal_owner"):
		var parent_legal_owner = get_parent().get_legal_owner()
		if parent_legal_owner != null:
			legal_owner = parent_legal_owner
	return legal_owner

func set_legal_owner(value):
	if is_instance_valid(value):
		legal_owner = value

func get_physical_owner():
	var parent = get_parent()
	if parent.has_method("get_physical_owner"):
		return get_parent().get_physical_owner()
	else:
		return self
