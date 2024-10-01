class_name Tile_nav

var misc = preload("res://scripts/Misc_functions.gd").new()

var grid : Grid_manager
var allow_diagonal_steps = true
var map = null 

const UNTRAVERSED = -1.0
const OCCUPIED = -2.0
const OBSTACLE = -3.0

func scan_routes(from : Vector2i, ignore_objects = false) -> void:
	map = grid.get_layout()
	map[from.y][from.x] = 0.0
	var traversal_queue = [from]
	
	while traversal_queue.size() > 0:
		var current = traversal_queue.pop_front()
		var current_distance = map[current.y][current.x]
		var neighbors = []
		
		if current.x != 0:
			neighbors.append(Vector2i(-1, 0)) # Left
			if allow_diagonal_steps:
				if current.y != grid.height - 1:
					neighbors.append(Vector2i(-1, 1)) # Top left
				if current.y != 0:
					neighbors.append(Vector2i(-1, -1)) # Bottom left
				
		if current.y != 0:
			neighbors.append(Vector2i(0, -1)) # Bottom
			
		if current.x != grid.width - 1:
			neighbors.append(Vector2i(1, 0))
			if allow_diagonal_steps:
				if current.y != grid.height - 1:
					neighbors.append(Vector2i(1, 1)) # Top right
				if current.y != 0:
					neighbors.append(Vector2i(1, -1)) # Bottom right
			
		if current.y != grid.height - 1:
			neighbors.append(Vector2i(0, 1)) # Top
			
		for neighbor in neighbors:
			var prev_distance = map[(current + neighbor).y][(current + neighbor).x]
			# diagonal moves cost sqrt(2.0)
			var delta_distance = sqrt(2.0) if abs(neighbor.x) + abs(neighbor.y) == 2 else 1.0
			
			if (prev_distance != OBSTACLE and (prev_distance != OCCUPIED or ignore_objects) and
			   (prev_distance == UNTRAVERSED or prev_distance > current_distance + delta_distance)):
				
				map[(current + neighbor).y][(current + neighbor).x] = current_distance + delta_distance
				traversal_queue.push_back(current + neighbor)
	return
	
func get_route(to: Vector2i):
	if map == null or map[to.y][to.x] < 0:
		return []
		
	var current = to
	var cur_distance = map[current.y][current.x]
	var route = []
	
	while cur_distance != 0.0:
		cur_distance = map[current.y][current.x]
		route.append(current)
		
		var neighbors = []
	
		if current.x != 0:
			neighbors.append(Vector2i(-1, 0)) # Left
			if allow_diagonal_steps:
				if current.y != grid.height - 1:
					neighbors.append(Vector2i(-1, 1)) # Top left
				if current.y != 0:
					neighbors.append(Vector2i(-1, -1)) # Bottom left
				
		if current.y != 0:
			neighbors.append(Vector2i(0, -1)) # Bottom
			
		if current.x != grid.width - 1:
			neighbors.append(Vector2i(1, 0))
			if allow_diagonal_steps:
				if current.y != grid.height - 1:
					neighbors.append(Vector2i(1, 1)) # Top right
				if current.y != 0:
					neighbors.append(Vector2i(1, -1)) # Bottom right
			
		if current.y != grid.height - 1:
			neighbors.append(Vector2i(0, 1)) # Top
			
		var distances = []
		for neighbor in neighbors:
			var dist = map[(current + neighbor).y][(current + neighbor).x]
			if dist >= 0:
				distances.append(map[(current + neighbor).y][(current + neighbor).x])
		if distances.size() == 0:
			return [] # no route found
			
		var minimum = distances.min()
		
		var valid_neighbors = []
		for neighbor in neighbors:
			if map[(current + neighbor).y][(current + neighbor).x] == minimum:
				valid_neighbors.append(current + neighbor)
		
		var next_tile = valid_neighbors.pick_random()	
		current = next_tile
	
	route.pop_back()
	return route
	
