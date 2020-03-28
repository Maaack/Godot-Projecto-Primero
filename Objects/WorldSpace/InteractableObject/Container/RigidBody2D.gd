extends "res://Objects/WorldSpace/InteractableObject/RigidBody2D.gd"


export(Resource) var contents setget set_contents

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
