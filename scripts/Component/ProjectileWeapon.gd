extends "res://scripts/WorldSpace/Node2D.gd"


export var fire_rate_per_second = 8
export var tracer_rate_per_second = 1
export var initial_bullet_impulse = 1000.0
export var bullet_self_destruct_timeout = 10.0

var legal_owner = null setget set_legal_owner
var tracer_list_owner = null setget set_tracer_list_owner

var bullet_scene = preload("res://objects/Bullet.tscn")
var tracer_scene = preload("res://objects/Tracer.tscn")

var fire_time_delta = 0.0
var tracer_time_delta = 0.0
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

func reset_bullet_trigger():
	fire_time_delta = 0.0
	
func reset_tracer_trigger():
	tracer_time_delta = 0.0
	
func add_tracer(object:Node2D):
	var instance = tracer_scene.instance()
	get_world_space().add_child(instance)
	instance.set_attached_to(object)
	get_physical_owner().get_tracer_list().append(instance)
	
func shoot_bullet(is_tracer_round:bool):
	var instance = spawn_bullet()
	instance.set_self_destruct_timeout(bullet_self_destruct_timeout)
	instance.set_physical_owner(get_physical_owner())
	push_bullet(instance)
	reset_bullet_trigger()
	if (is_tracer_round):
		add_tracer(instance)
		reset_tracer_trigger()
	
func spawn_bullet():
	var instance = bullet_scene.instance()
	get_world_space().add_child(instance)
	instance.set_position(get_position_in_world_space())
	instance.set_rotation(get_rotation_in_world_space())
	instance.set_linear_velocity(get_physical_owner().get_linear_velocity())
	return instance
	
func push_bullet(instance:RigidBody2D):
	var bullet_impulse = Vector2(0,-1).rotated(get_rotation_in_world_space()) * initial_bullet_impulse
	instance.apply_central_impulse(bullet_impulse)
	push_back_physical_owner(bullet_impulse, instance)
	
func push_back_physical_owner(bullet_impulse:Vector2, instance:RigidBody2D):
	var physical_owner = get_physical_owner()
	var impulse_offset = get_position_in_ancestor(physical_owner).rotated(get_rotation_in_world_space())
	var owner_impulse = -bullet_impulse * ( instance.get_mass() / physical_owner.get_mass() )
	physical_owner.apply_impulse(impulse_offset, owner_impulse)
	
func process(delta):
	fire_time_delta += delta
	tracer_time_delta += delta
	if is_triggered:
		if fire_time_delta > (1.0 / fire_rate_per_second) :
			var is_tracer_round = false
			if tracer_time_delta > (1.0 / tracer_rate_per_second):
				is_tracer_round = true
				tracer_time_delta = 0.0
			shoot_bullet(is_tracer_round)

func get_physical_owner():
	return get_parent().get_physical_owner()
