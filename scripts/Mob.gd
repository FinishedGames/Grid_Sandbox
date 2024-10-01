extends Node

@export var grid_agent : Grid_actor

var route = []
var nav = Tile_nav.new()

func _ready() -> void:
	nav.grid = grid_agent.grid
	nav.allow_diagonal_steps = false
	pass

func next_step(prev_success):
	if prev_success and route.size() > 0:
		grid_agent.step_to(route.pop_back(), next_step)
	
func go_to(dest : Vector2i):
	nav.scan_routes(grid_agent.get_grid_pos())
	route = nav.get_route(dest)
	next_step(true)
	
func stop():
	route = []
