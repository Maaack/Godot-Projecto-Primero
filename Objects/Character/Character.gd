extends "res://Objects/WorldSpace/Ownable/Node2D.gd"


const BASE_ORIENTATION = PI/2

export var camera_scale = 0.2
export(NodePath) var initial_ship_path
var ship_node = null

# Currency
export var money = 0.0

func _ready():
	var initial_ship_node = get_node(initial_ship_path)
	if initial_ship_node != null and is_instance_valid(initial_ship_node):
		command_ship(initial_ship_node)

func _physics_process(delta):
	if not is_instance_valid(ship_node):
		ship_node = null
		return # Dead?
	set_position(ship_node.get_position())
	set_rotation(ship_node.get_rotation())

func _input(event):
	if not is_instance_valid(ship_node):
		ship_node = null
		return
	ship_node.input(event)

func reward(amount:float):
	money += amount

func get_physical_owner():
	return self

func command_ship(ship:Node2D):
	if ship == ship_node:
		return true
	if ship.has_method("input"):
		ship_node = ship
		ship.set_commander(self)

func _on_PhysicsArea_body_exited(body):
	if body.has_method('exit_physics_area'):
		body.exit_physics_area()
