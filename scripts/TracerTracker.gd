extends Node2D


onready var sprite = $Sprite

var view_centered_on = null


func set_centered_on(target):
	if target.get_position() != null:
		view_centered_on = target

func set_color(color):
	sprite.set_modulate(color)
