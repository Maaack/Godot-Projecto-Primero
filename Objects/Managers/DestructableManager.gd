var destructable

var last_linear_velocity
var last_damaged_by

var destroyed = false
var destroyable = true

func _init(init_destructable=null):
	if init_destructable != null and init_destructable is Destructable:
		destructable = init_destructable

func physics_process(delta, object:RigidBody2D, sprite:Sprite):
	var linear_force = get_linear_force(delta, object)
	var centripital_force = get_centripital_force(delta, object, sprite)
	var total_forces = linear_force + centripital_force
	if total_forces > destructable.force_tolerance:
		var total_damage = (total_forces - destructable.force_tolerance) * destructable.force_damage
		damage(total_damage, null)
	set_last_values(object)

func set_last_values(object:RigidBody2D):
	last_linear_velocity = object.linear_velocity

func can_destroy():
	if destroyed:
		return false
	return destroyable

func destroy_self():
	if can_destroy():
		destroyed = true

func get_linear_force(delta, object:RigidBody2D):
	if last_linear_velocity == null:
		return 0.0
	var linear_velocity_delta = (last_linear_velocity - object.linear_velocity).length()
	var mass = object.mass
	return mass * (linear_velocity_delta / delta)

func get_centripital_force(delta, object:RigidBody2D, sprite:Sprite):
	var mass = object.mass
	var radius = 1.0
	if sprite != null and sprite.texture != null:
		radius = (sprite.texture.get_size() / 2).length()
		
	var edge_velocity = get_edge_velocity2(delta, object, radius)
	return ( mass / 2 ) * pow(edge_velocity, 2) / radius

func get_edge_velocity(delta, object:RigidBody2D, sprite:Sprite):
	var size = Vector2(1.0, 1.0)
	if sprite != null and sprite.texture != null:
		size = sprite.texture.get_size() / 2 # Assuming spinning around the center
	var total_angular_velocity = delta * object.angular_velocity
	return (size.rotated(total_angular_velocity) - size).length() / delta

func get_edge_velocity2(delta, object:RigidBody2D, radius:float):
	var radius_vector = Vector2(radius, 0)
	var total_angular_velocity = delta * object.angular_velocity
	var position_delta = (radius_vector.rotated(total_angular_velocity) - radius_vector).length()
	return position_delta / delta

func get_health():
	if is_instance_valid(destructable):
		return destructable.physical_collection.get_quantity_value(destructable.unit_key)
	return 0.0

func has_health():
	return get_health() > 0.0

func add_to_health(value:float):
	if is_instance_valid(destructable):
		var health_quantity = destructable.get_specific_quantity().duplicate()
		health_quantity.quantity = value
		return destructable.physical_collection.add_physical_quantity(health_quantity)

func damage(amount:float, from:Node2D):
	var had_health = has_health()
	add_to_health(-amount)
	last_damaged_by = from
	if not has_health() and had_health:
		destroy_self()
	
func impact(relative_velocity: Vector2, object_mass: float, from: Node2D):
	var impact_force = 0.5 * object_mass * relative_velocity.length_squared()
	var damage = impact_force/1000
	if damage > 0:
		damage(damage, from)
