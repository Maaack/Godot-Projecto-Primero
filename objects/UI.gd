extends Control

var target_angle = 0.0 setget set_target_angle


func set_target_angle(value):
	target_angle = value
	var arrow = get_node("/root/UI/CenterContainer/Arrow/Canvas")
	arrow.rotation = target_angle

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_target_angle(target_angle + 1.0)
