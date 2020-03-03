extends Node2D

onready var arrow = $Arrow
var arrow_rotation = 0 setget set_arrow_rotation

func set_arrow_rotation(value):
	arrow_rotation = value
	rotation = arrow_rotation
