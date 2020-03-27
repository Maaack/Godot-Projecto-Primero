extends "res://Objects/WorldSpace/InteractableObject/Node2D.gd"


const BASE_IMPULSE_VECTOR = Vector2(1,0)
const BASE_ORIENTATION = -PI/2
export var initial_bullet_impulse = 800.0
export var bullet_self_destruct_timeout = 10.0
export var max_loaded_munitions = 1
export var max_firing_munitions = 1

var loaded_munitions = null
var fire_time_delta = 0.0
var is_triggered = false

func trigger_on():
	is_triggered = true
	
func trigger_off():
	is_triggered = false
	
func is_loaded():
	return loaded_munitions != null

func is_empty():
	return loaded_munitions == null
	
func load_munitions(munitions:PhysicalQuantity):
	if munitions == null:
		return
	if munitions.quantity > max_loaded_munitions:
		return
	loaded_munitions = munitions
	return loaded_munitions

func spawn_bullet(bullet_unit:PackedSceneUnit):
	var instance = bullet_unit.packed_scene.instance()
	bullet_unit.position = get_position_in_world_space()
	bullet_unit.rotation = get_rotation_in_world_space()
	bullet_unit.linear_velocity = get_physical_owner().get_linear_velocity()
	world_space.add_child(instance)
	instance.physical_unit = bullet_unit
	return instance

func fire_munitions():
	if is_loaded():
		trigger_off()
		for i in range(loaded_munitions.quantity):
			var firing_munition = loaded_munitions.physical_unit
			loaded_munitions.quantity -= 1
			var instance = spawn_bullet(firing_munition)
			instance.set_self_destruct_timeout(bullet_self_destruct_timeout)
			instance.set_legal_owner(get_legal_owner())
			if firing_munition.group_name == "TRACER_BULLET":
				add_tracer(instance)
			push_bullet(instance)
		if loaded_munitions.quantity == 0:
			loaded_munitions = null

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
		fire_munitions()
		fire_time_delta = 0.0
