extends Node2D


onready var space = get_parent()
var attached_to = null


func _physics_process(delta):
	if attached_to == null or not is_instance_valid(attached_to):
		remove_self()
		return
	update_pos_and_rot()
		
func update_pos_and_rot():
	set_position(attached_to.get_position())
	set_rotation(attached_to.get_rotation())

func remove_self():
	space.remove_object_path(get_parent(), get_path())
	
func set_attached_to(target):
	if is_instance_valid(target) and target.get_position() != null:
		attached_to = target
		update_pos_and_rot()
