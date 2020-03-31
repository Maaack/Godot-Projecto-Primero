extends Node2D


onready var button_node = $Button

export(Resource) var physical_unit setget set_physical_unit

var is_button_pressed = false

signal mouse_entered
signal mouse_exited
signal button_down
signal button_up
signal button_pressed
signal button_toggled

func set_physical_unit(value:PhysicalUnit):
	if value == null:
		return
	physical_unit = value
	button_node.physical_unit = value

func _on_Button_mouse_entered():
	emit_signal("mouse_entered")

func _on_Button_mouse_exited():
	if not is_button_pressed:
		emit_signal("mouse_exited")

func _on_Button_button_down():
	emit_signal("button_down")

func _on_Button_button_up():
	emit_signal("button_up")

func _on_Button_pressed():
	emit_signal("button_pressed")

func _on_Button_toggled(button_pressed):
	if button_pressed == null:
		return
	is_button_pressed = button_pressed
	emit_signal("button_toggled", button_pressed)
