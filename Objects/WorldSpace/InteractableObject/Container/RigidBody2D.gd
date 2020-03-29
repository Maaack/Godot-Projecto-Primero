extends "res://Objects/WorldSpace/InteractableObject/RigidBody2D.gd"


export(Resource) var contents setget set_contents
var init_mass

func _ready():
	init_mass = mass

func _physics_process(delta):
	update_mass()

func update_mass():
	if contents == null:
		return
	if init_mass == null or init_mass == 0.0:
		return
	mass = init_mass + contents.get_mass()

func set_contents(value:PhysicalCollection):
	if value != null:
		contents = value.duplicate()
	else:
		contents = PhysicalCollection.new()

func get_contents_array():
	if contents == null:
		return
	return contents.physical_quantities.duplicate()

func add_quantity_to_contents(quantity:PhysicalQuantity):
	contents.add_physical_quantity(quantity)
