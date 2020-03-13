extends "res://scripts/Component/Base/Ownable/RigidBody2D.gd"


var current_commander = null

func input(event):
	print("Should override input method in ", str(get_path()).get_file())

func set_commander(commander:Node2D):
	current_commander = commander
	legal_owner = commander
