extends "res://scripts/Component/Base/BasicSystem.gd"


const BASE_IMPULSE_VECTOR = Vector2(1,0)
const BASE_ORIENTATION = -PI/2
export var initial_bullet_impulse = 1000.0
export var bullet_self_destruct_timeout = 10.0

var legal_owner = null setget set_legal_owner
var tracer_list_owner = null setget set_tracer_list_owner

var bullet_scene = preload("res://objects/Bullet.tscn")
var tracer_scene = preload("res://objects/Tracer.tscn")

var loaded_munition = null
var fire_time_delta = 0.0
var is_triggered = false

func set_legal_owner(object:Node2D):
	if is_instance_valid(object):
		legal_owner = object
		
func set_tracer_list_owner(object:Node2D):
	if is_instance_valid(object):
		tracer_list_owner = object
		
func set_all_owner(object:Node2D):
	if is_instance_valid(object):
		set_legal_owner(object)
		set_tracer_list_owner(object)

func trigger_on():
	is_triggered = true
	
func trigger_off():
	is_triggered = false
	
func is_munition_loaded():
	return loaded_munition != null
	
func load_munition(settings_dict = {}):
	if loaded_munition == null:
		loaded_munition = settings_dict
		return true
	return false
		
func fire_munition():
	if loaded_munition != null:
		var instance = spawn_bullet()
		instance.set_self_destruct_timeout(bullet_self_destruct_timeout)
		instance.set_physical_owner(get_physical_owner())
		if (loaded_munition.has('is_tracer_round')):
			add_tracer(instance)
		loaded_munition = null
		fire_time_delta = 0.0
		return instance
	
func add_tracer(object:Node2D):
	var instance = tracer_scene.instance()
	get_world_space().add_child(instance)
	instance.set_attached_to(object)
	get_physical_owner().get_tracer_list().append(instance)
	
func spawn_bullet():
	var instance = bullet_scene.instance()
	get_world_space().add_child(instance)
	instance.set_position(get_position_in_world_space())
	instance.set_rotation(get_rotation_in_world_space())
	instance.set_linear_velocity(get_physical_owner().get_linear_velocity())
	return instance
	
func push_bullet(instance:RigidBody2D):
	var bullet_impulse = (BASE_IMPULSE_VECTOR * initial_bullet_impulse).rotated(get_rotation_in_world_space()).rotated(BASE_ORIENTATION)
	instance.apply_central_impulse(bullet_impulse)
	push_back_physical_owner(bullet_impulse, instance)
	
func push_back_physical_owner(bullet_impulse:Vector2, instance:RigidBody2D):
	var physical_owner = get_physical_owner()
	var rotate_offset = physical_owner.get_rotation_in_world_space()
	var impulse_offset = get_position_in_ancestor(physical_owner).rotated(rotate_offset)
	var owner_impulse = -bullet_impulse * ( instance.get_mass() / physical_owner.get_mass() )
	physical_owner.apply_impulse(impulse_offset, owner_impulse)
	
func process(delta):
	fire_time_delta += delta
	if is_triggered and is_munition_loaded():
		var munition = fire_munition()
		push_bullet(munition)
