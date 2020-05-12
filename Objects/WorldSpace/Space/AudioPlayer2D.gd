extends AudioStreamPlayer


onready var initial_volume_db = volume_db

export (int) var volume_steps = 10

var muted : bool = true
var volume_range : float = 1

func _input(event):
	if event.is_action_pressed("ui_mute"):
		muted = !(muted)
	elif event.is_action_pressed("ui_volume_up"):
		if volume_range < 1:
			volume_range = min(volume_range + 1/volume_steps, 1)
	elif event.is_action_pressed("ui_volume_down"):
		if volume_range > 0:
			volume_range = max(volume_range - 1/volume_steps, 0)
	volume_db = initial_volume_db + linear2db(volume_range)

func set_playing(value:bool):
	if muted:
		playing = false
		return
	playing = value
