extends "res://Objects/ThingsInSpace/BasicTarget/BasicTarget.gd"


onready var icon = $Sprite/Icon

export(Resource) var collection

func _ready():
	collection = collection.duplicate()
	icon.texture = collection.icon

func _on_Area2D_body_entered(body):
	if body.has_method("collect"):
		body.collect(collection)
		queue_free()
