extends "res://Objects/Ownable/Container.gd"


var current_commander = null

func input(event):
	print("Warning: Should override input method in ", str(get_path()).get_file())

func set_commander(commander:Node2D):
	current_commander = commander
	legal_owner = commander
