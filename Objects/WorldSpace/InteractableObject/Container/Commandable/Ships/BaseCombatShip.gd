extends "res://Objects/WorldSpace/InteractableObject/Container/Commandable/CombatShip.gd"


func _on_CollectableArea_body_entered(body):
	if contents.has_empty_space(body.physical_quantity.get_area()):
		if body.has_method('collect'):
			var quantity = body.collect()
			add_quantity_to_contents(quantity)
