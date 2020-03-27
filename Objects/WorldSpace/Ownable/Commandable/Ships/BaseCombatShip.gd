extends "res://Objects/WorldSpace/Ownable/Commandable/CombatShip.gd"


func _on_CollectableArea_body_entered(body):
	var empty_space = contents.get_empty_space()
	if empty_space > 0:
		if body.has_method('collect'):
			var quantity = body.collect()
			add_quantity_to_contents(quantity)
