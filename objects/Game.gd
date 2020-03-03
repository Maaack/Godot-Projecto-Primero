extends Control

onready var space = $MainViewportContainer/Viewport/Space
onready var character = $MainViewportContainer/Viewport/Space/Character
onready var station = $MainViewportContainer/Viewport/Space/Station
onready var planet8 = $MainViewportContainer/Viewport/Space/Planet8
onready var arrow_1_hud = $CenterContainer/Control/Arrow_1
onready var arrow_2_hud = $CenterContainer/Control/Arrow_2
onready var rotation_hud = $Rotation/Value
onready var angle_hud = $AngleTo/Value

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	rotation_hud.set_text(str(character.rotation))
	arrow_1_hud.rotation = character.get_angle_to_target(station)
	arrow_2_hud.rotation = character.get_angle_to_target(planet8)
