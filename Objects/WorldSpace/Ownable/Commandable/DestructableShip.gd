extends "res://Objects/WorldSpace/Ownable/Commandable/CombatShip.gd"


onready var ship_sprite = $Sprite
onready var DestructableManager = preload("res://Objects/Managers/DestructableManager.gd")
export(Resource) var destuctable_object
var destructable_manager


func _ready():
	destructable_manager = DestructableManager.new()

func _physics_process(delta):
	destructable_manager.physics_process(delta, self, ship_sprite)
	if destructable_manager.destroyed == true:
		queue_free()
