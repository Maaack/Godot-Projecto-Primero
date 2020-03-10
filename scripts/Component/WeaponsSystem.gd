extends "res://scripts/WorldSpace/Node2D.gd"
	
	
const FIRE_GROUP_MODE_ALL = 0
const FIRE_GROUP_MODE_CYCLE = 1

export(Array, NodePath) var initial_weapon_paths = []
var weapons = []
var next_weapon_index = 0
var fire_group_mode = FIRE_GROUP_MODE_ALL
var is_triggered = false
onready var all_owner = get_parent()

func _ready():
	for weapon_path in initial_weapon_paths:
		var weapon = get_node(weapon_path)
		add_weapon(weapon)
		
func process(delta):
	process_weapon_groups()
	process_weapons(delta)
	
func cycle_weapon():
	next_weapon_index = (next_weapon_index + 1) % weapons.size()
	
func process_weapon_groups():
	if is_triggered:
		if fire_group_mode == FIRE_GROUP_MODE_ALL:
			for weapon in weapons:
				if weapon.has_method("trigger_on"):
					weapon.trigger_on()
		elif fire_group_mode == FIRE_GROUP_MODE_CYCLE:
			var weapon = weapons[next_weapon_index]
			if weapon != null and weapon.has_method("trigger_off"):
				weapon.trigger_on()
			cycle_weapon()
	else:
		for weapon in weapons:
			if weapon.has_method("trigger_off"):
				weapon.trigger_off()
				
func process_weapons(delta):
	for weapon in weapons:
		if weapon.has_method("process"):
			weapon.process(delta)
			
func trigger_on():
	is_triggered = true
	
func trigger_off():
	is_triggered = false
	
func add_weapon(weapon:Node2D):
	if not weapons.has(weapon):
		weapons.append(weapon)
	
func remove_weapon(weapon:Node2D):
	if weapons.has(weapon):
		var index = weapons.find(weapon)
		weapons.remove(index)

func reset_weapons():
	var new_weapons = []
	for weapon in weapons:
		if is_instance_valid(weapon):
			new_weapons.append(weapon)
	weapons = new_weapons
	if next_weapon_index > weapons.size():
		next_weapon_index = 0
