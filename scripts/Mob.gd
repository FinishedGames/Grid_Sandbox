extends Node

@export var grid_agent : Grid_actor
@export var input_mgr : Input_manager

@export var period = 1.0
var cooldown

func _ready() -> void:
	cooldown = period

func _process(delta: float) -> void:
	cooldown -= delta
	
	if cooldown <= 0:
		cooldown = period
		var random = range(4).pick_random()
		
		if random == 0:
			grid_agent.step(Vector2i(0, -1))
		elif random == 1:
			grid_agent.step(Vector2i(1, 0))
		elif random == 2:
			grid_agent.step(Vector2i(0, 1))
		elif random == 3:
			grid_agent.step(Vector2i(-1, 0))
