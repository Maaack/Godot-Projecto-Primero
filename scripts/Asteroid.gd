extends RigidBody2D


onready var space = get_parent()
export(float) var health = 64.0

func _ready():
	set_start_position()
	set_start_velocity()

func _process(delta):
	process_physical_limitations(delta)

func process_physical_limitations(delta):
	if not space.is_in_world(position):
		remove_self()
	if health < 0.0:
		remove_self()

func set_start_position():
	position = space.get_random_spawn_position()

func set_start_velocity():
	var velocity = space.get_random_space_whale_start_velocity()
	set_axis_velocity(velocity)
	
func remove_self():
	var node = get_parent()
	space.asteroid_counter -= 1
	node.remove_object_path(get_parent(), get_path())
	
func damage(amount:float):
	print("Damage! ", amount)
	health -= amount
	
func impact(relative_velocity: Vector2, object_mass: float):
	var impact_force = 0.5 * object_mass * relative_velocity.length_squared()
	damage(impact_force/1000)
