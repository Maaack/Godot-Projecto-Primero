extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const ZOOM_RATIO = 0.8
const ZOOM_MAX_LEVELS = 9


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				zoom *= ZOOM_RATIO
			if event.button_index == BUTTON_WHEEL_DOWN:
				zoom *= 1/ZOOM_RATIO
			if zoom.x <= pow(ZOOM_RATIO, ZOOM_MAX_LEVELS):
				zoom *= 1/ZOOM_RATIO
			elif zoom.x >= pow(1/ZOOM_RATIO, ZOOM_MAX_LEVELS):
				zoom *= ZOOM_RATIO
