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
	set_icon(value.physical_unit)
	label_node.set_text(str(quantity.quantity))

func set_icon(value:PhysicalUnit):
	if value == null:
		return
	texture_node.texture = value.icon
	var get_size = texture_node.texture.get_size()
	var scale_mod = texture_desired_size/get_size
	texture_node.rect_scale = scale_mod

func update_counter():
	if quantity == null:
		return
	var value = quantity.quantity
	if quantity.physical_unit.numerical_unit == quantity.physical_unit.NumericalUnitSetting.DISCRETE:
		value = str(round(value))
	else:
		value = "%3.2f" % value
	set_counter(value)

func set_counter(value):
	label_node.set_text(str(value))
	
