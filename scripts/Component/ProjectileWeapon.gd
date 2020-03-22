extends "res://Objects/Ownable/Node2D.gd"


const BASE_IMPULSE_VECTOR = Vector2(1,0)
const BASE_ORIENTATION = -PI/2
export var initial_bullet_impulse = 800.0
export var bullet_self_destruct_timeout = 10.0

var loaded_munition = null
var fire_time_delta = 0.0
var is_triggered = false

func trigger_on():
	is_triggered = true
	
func trigger_off():
	is_triggered = false
	
func is_loaded():
	return loaded_munition != null

func is_empty():
	return loaded_munition == null
	
func load_munition(munition:Ownable):
	if loaded_munition == null:
		loaded_munition = munition
		return true
	return false
		
func spawn_bullet(bullet_scene:PackedScene):
	var instance = bullet_scene.instance()
	world_space.add_child(instance)
	instance.set_position(get_position_in_world_space())
	instance.set_rotation(get_rotation_in_world_space())
	instance.set_linear_velocity(get_physical_owner().get_linear_velocity())
	return instance

func fire_munition():
	if is_loaded():
		trigger_off()
		var firing_munition = loaded_munition
		loaded_munition = null
		var instance = spawn_bullet(firing_munition.packed_scene)
		instance.set_self_destruct_timeout(bullet_self_destruct_timeout)
		instance.set_legal_owner(get_legal_owner())
		if firing_munition.group_name == "TRACER_BULLET":
			add_tracer(instance)
		return instance

func add_tracer(object:Node2D):
	get_physical_owner().get_tracer_list().append(object)

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
	if is_triggered and is_loaded():
		var munition = fire_munition()
		push_bullet(munition)
		fire_time_delta = 0.0
