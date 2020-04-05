extends VBoxContainer


var progress_bar_scene = preload("res://Objects/Interface/ProgressBar/ProgressBar.tscn")

var container_progress_bar_map = {}

func add_progress_bar(specific_container:SpecificContainer):
	if specific_container == null:
		return
	var progress_bar
	if container_progress_bar_map.has(specific_container):
		progress_bar = container_progress_bar_map[specific_container]
		progress_bar.show()
		return progress_bar
	progress_bar = progress_bar_scene.instance()
	add_child(progress_bar)
	container_progress_bar_map[specific_container] = progress_bar
	progress_bar.specific_container = specific_container

func hide_all():
	for child in get_children():
		child.hide()
