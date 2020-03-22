extends "res://Objects/Ownable/RigidBody2D.gd"


export(Array, Resource) var contents = []

func _ready():
	var new_contents = []
	for content in contents:
		new_contents.append(content.duplicate())
	contents = new_contents

func get_contents():
	return contents

func add_contents(collection:Ownables):
	for content in contents:
		if content.group_name == collection.group_name:
			content.count += collection.count
			return
	contents.append(collection)
	
func collect(collection:Ownables):
	add_contents(collection)
