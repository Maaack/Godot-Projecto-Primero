extends Node2D


export var fire_rate_per_second = 8
export var tracer_rate_per_second = 1
export var initial_bullet_impulse = 1000.0
export var bullet_self_destruct_timeout = 10.0

var legal_owner = null setget set_legal_owner
var tracer_list_owner = null setget set_tracer_list_owner
var physics_owner = null setget set_physics_owner
var world_space = null setget set_world_space

var bullet_scene = preload("res://objects/Bullet.tscn")
var tracer_scene = preload("res://objects/Tracer.tscn")

var is_weapon_triggered = false
var fire_time_delta = 0.0
var tracer_time_delta = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_legal_owner(object:Node2D):
	if is_instance_valid(object):
		legal_owner = object
		
func set_tracer_list_owner(object:Node2D):
	if is_instance_valid(object):
		tracer_list_owner = object
		
func set_physics_owner(object:Node2D):
	if is_instance_valid(object):
		tracer_list_owner = object
		
func set_all_owner(object:Node2D):
	if is_instance_valid(object):
		set_legal_owner(object)
		set_tracer_list_owner(object)
		set_physics_owner(object)

func set_world_space(object:Node2D):
	if is_instance_valid(object):
		world_space = object

func trigger_weapon(trigger:bool):
	is_weapon_triggered = trigger

func add_tracer(object:Node2D):
	var instance = tracer_scene.instance()
	world_space.add_child(instance)
	instance.set_attached_to(object)
	tracer_list_owner.get_tracer_list().append(instance)
	
func spawn_bullet(is_tracer_round:bool):
	var instance = bullet_scene.instance()
	var bullet_spawn_position = get_position().rotated(get_rotation())
	var final_bullet_impulse = Vector2(0,-1).rotated(get_rotation()) * initial_bullet_impulse
	world_space.add_child(instance)
	instance.set_position(bullet_spawn_position)
	instance.set_linear_velocity(legal_owner.get_linear_velocity())
	instance.set_rotation(get_rotation())
	instance.apply_central_impulse(final_bullet_impulse)
	instance.set_legal_owner(legal_owner)
	instance.set_self_destruct_timeout(bullet_self_destruct_timeout)
	if (is_tracer_round):
		add_tracer(instance)
	legal_owner.apply_central_impulse(-final_bullet_impulse * ( instance.mass / legal_owner.mass ))
	
func process(delta):
	fire_time_delta += delta
	tracer_time_delta += delta
	if is_weapon_triggered:
		if fire_time_delta > (1.0 / fire_rate_per_second) :
			var is_tracer_round = false
			if tracer_time_delta > (1.0 / tracer_rate_per_second):
				is_tracer_round = true
				tracer_time_delta = 0.0
			spawn_bullet(is_tracer_round)
			fire_time_delta = 0.0
