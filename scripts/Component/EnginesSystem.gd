extends Node2D
	
	
const FIRE_GROUP_MODE_ALL = 0
const FIRE_GROUP_MODE_CYCLE = 1

export(Array, NodePath) var initial_engine_paths = []
var engines = []
var is_triggered = false
onready var all_owner = get_parent()

func _ready():
	for engine_path in initial_engine_paths:
		var engine = get_node(engine_path)
		add_engine(engine)
		
func process(delta):
	process_engine_groups()
	process_engines(delta)
	
func process_engine_groups():
	if is_triggered:
		for engine in engines:
			if engine.has_method("trigger_engine"):
				engine.trigger_engine()
	else:
		for engine in engines:
			if engine.has_method("untrigger_engine"):
				engine.untrigger_engine()
				
func process_engines(delta):
	for engine in engines:
		if engine.has_method("process"):
			engine.process(delta)
			
func trigger_on():
	is_triggered = true
	
func trigger_off():
	is_triggered = false
	
func add_engine(engine:Node2D):
	if not engines.has(engine):
		engines.append(engine)
		engine.set_all_owner(all_owner)
	
func remove_engine(engine:Node2D):
	if engines.has(engine):
		var index = engines.find(engine)
		engines.remove(index)

func reset_engines():
	var new_engines = []
	for engine in engines:
		if is_instance_valid(engine):
			new_engines.append(engine)
	engines = new_engines
