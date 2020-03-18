extends "res://scripts/BasicTarget.gd"


export var armor = 1.0
var set_orbit_on_next_integrate_forces = true
enum OrbitDirectionSetting{CLOCKWISE, COUNTER_CLOCKWISE, EITHER}

func set_orbit_velocity(state:Physics2DDirectBodyState):
	var gravity_force = state.get_total_gravity().length()
	var current_velocity = state.linear_velocity
	print(current_velocity, gravity_force)
	state.set_linear_velocity(current_velocity * gravity_force)

func remove_self():
	get_world_space().asteroid_space.asteroid_counter -= 1
	queue_free()
	
#func _integrate_forces(state):
#	if set_orbit_on_next_integrate_forces and state.get_total_gravity() != Vector2(0,0):
#			set_orbit_velocity(state)
#			set_orbit_on_next_integrate_forces = false
