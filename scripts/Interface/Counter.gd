extends NinePatchRect

enum CounterSetting {NORMAL, DIVIDED_BY, PERCENT}
export(CounterSetting) var counter_setting
export(float) var value = 0.0
export(float) var divided_by = null
onready var label_node = $Label

func _ready():
	set_counter(value)

func set_counter(new_value):
	var counter_string = str(new_value)
	if counter_setting == CounterSetting.DIVIDED_BY and divided_by > 0:
		counter_string += '/' + str(divided_by)
	elif counter_setting == CounterSetting.PERCENT:
		counter_string += '%'
	label_node.set_text(counter_string)
	value = new_value
