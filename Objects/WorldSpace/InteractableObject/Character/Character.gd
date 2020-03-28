extends "res://Objects/WorldSpace/InteractableObject/Container/Node2D.gd"


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

func get_contents_array():
	var contents_array = .get_contents_array()
	if is_instance_valid(ship_node) and ship_node.has_method("get_contents_array"):
		contents_array += ship_node.get_contents_array()
	return contents_array

func get_vitals_array():
	if ship_node == null:
		return
	return [ship_node.destructable]

func reward(quantities_array:Array):
	if quantities_array == null or quantities_array.size() == 0:
		return
	if contents == null:
		contents = PhysicalCollection.new()
	for quantity in quantities_array:
		contents.add_physical_quantity(quantity)

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