extends AudioStreamPlayer2D


onready var initial_volume_db = volume_db

export (int) var volume_steps = 10

var volume_range : float = 1
var muted : bool = false

func _input(event):
	if event.is_action_pressed("ui_mute"):
		muted = !(muted)
	elif event.is_action_pressed("ui_volume_up"):
		if volume_range < 1.0:
			volume_range = min(volume_range + 1.0/volume_steps, 1.0)
	elif event.is_action_pressed("ui_volume_down"):
		if volume_range > 0.0:
			volume_range = max(volume_range - 1.0/volume_steps, 0.0)
	update_volume()

func play(from_position : float = 0):
	if muted:
		return
	.play(from_position)

func update_volume():
	volume_db = initial_volume_db + linear2db(volume_range)
