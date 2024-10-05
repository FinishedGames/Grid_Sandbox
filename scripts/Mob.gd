extends Node
class_name Mob

@onready var grid_agent : Grid_actor = $".."
@onready var nav : Grid_nav = $Nav

var route = []

func _ready() -> void:
	pass

func next_step(prev_success):
	if route.size() > 0:
		if prev_success:
			grid_agent.step_to(route.pop_back(), next_step)
		else: # attempt to re-generate route
			go_to(route.front())
			
func go_to(dest : Vector2i):
	nav.scan_routes(grid_agent.get_grid_pos(), false, dest)
	route = nav.get_route(dest)
	next_step(true)
	
func stop():
	route = []
