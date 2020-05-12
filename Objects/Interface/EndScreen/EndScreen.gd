extends Control


signal end_game_triggered


func _on_Button_pressed():
	emit_signal("end_game_triggered")
	get_tree().quit()
