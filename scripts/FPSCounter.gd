extends Label

onready var value_label = $Value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var fps = 1 / delta
	value_label.set_text(str(fps))
