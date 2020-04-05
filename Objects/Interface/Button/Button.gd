extends TextureButton


onready var icon_node = $Icon

export(Resource) var physical_unit setget set_physical_unit

signal attention_on
signal attention_off
signal button_toggled

func _ready():
	update_icon()

func set_physical_unit(value:PhysicalUnit):
	if value == null:
		return
	physical_unit = value
	update_icon()

func update_icon():
	if physical_unit == null or icon_node == null:
		return
	icon_node.physical_unit = physical_unit
	icon_node.show()

func _on_Button_mouse_entered():
	emit_signal("attention_on", physical_unit)

func _on_Button_mouse_exited():
	if not pressed:
		emit_signal("attention_off", physical_unit)

func _on_Button_tree_exiting():
	emit_signal("attention_off", physical_unit)

func _on_Button_toggled(button_pressed:bool):
	emit_signal("button_toggled", button_pressed, physical_unit)
