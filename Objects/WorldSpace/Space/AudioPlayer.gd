extends AudioStreamPlayer

const VOLUME_MAX = 0.0
const VOLUME_MIN = -50.0

var muted : bool = false
var volume_step_size = VOLUME_MAX - VOLUME_MIN / (10)


func _input(event):
	if event.is_action_pressed("ui_mute"):
		playing = !(playing)
	elif event.is_action_pressed("ui_volume_up"):
		if volume_db < VOLUME_MAX:
			volume_db = min(volume_db + volume_step_size, VOLUME_MAX)
	elif event.is_action_pressed("ui_volume_down"):
		if volume_db > VOLUME_MIN:
			volume_db = max(volume_db - volume_step_size, VOLUME_MIN)
