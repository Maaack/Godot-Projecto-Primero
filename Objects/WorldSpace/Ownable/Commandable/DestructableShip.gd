extends "res://Objects/WorldSpace/Ownable/Commandable/CombatShip.gd"


onready var ship_sprite = $Sprite

func _on_CollectableArea_body_entered(body):
	var empty_space = contents.get_empty_space()
	print("EmptySpace: ", empty_space, " ", empty_space > 0.0, " ", empty_space > 0.000001, " ", empty_space > 0.0000001)
	if empty_space > 0:
		if body.has_method('collect'):
			add_quantity_to_contents(body.collect())
