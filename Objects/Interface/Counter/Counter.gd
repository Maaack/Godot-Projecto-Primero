extends NinePatchRect


export(Resource) var quantity setget set_quantity
onready var label_node = $Label
onready var texture_node = $Texture

var texture_desired_size = Vector2(24.0, 24.0)

func _process(delta):
	update_counter()

func set_quantity(value:PhysicalQuantity):
	if value == null:
		return
	quantity = value
	set_icon(value)
	update_counter()

func set_icon(value:PhysicalUnit):
	if value == null:
		return
	if value.icon == null:
		print(value, " doesn't have an icon!")
		return
	texture_node.texture = value.icon
	var get_size = texture_node.texture.get_size()
	var scale_mod = texture_desired_size/get_size
	texture_node.rect_scale = scale_mod

func update_counter():
	if quantity == null:
		return
	var value = quantity.quantity
	if quantity.numerical_unit == quantity.NumericalUnitSetting.DISCRETE:
		value = round(value)
	else:
		var value_str = "%.*f"
		var precision = 0
		var abs_value = abs(value)
		if abs_value != 0:
			if abs_value < 100:
				precision += 1
			if abs_value < 10:
				precision += 1
			if abs_value < 1:
				precision += 1
		value = value_str % [precision, value]
	set_counter(value)

func set_counter(value):
	label_node.set_text(str(value))
	
