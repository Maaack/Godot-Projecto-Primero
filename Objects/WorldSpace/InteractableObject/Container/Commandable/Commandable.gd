extends "res://Objects/WorldSpace/InteractableObject/Container/RigidBody2D.gd"


var current_commander = null

func input(event):
	print("Warning: Should override input method in ", str(get_path()).get_file())

func set_commander(commander:Node2D):
	current_commander = commander
	legal_owner = commander