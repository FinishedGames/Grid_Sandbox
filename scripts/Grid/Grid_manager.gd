extends Node
class_name Grid_manager

@onready var background : TileMapLayer = $Background
@onready var floor : TileMapLayer = $Background/Floor
@onready var solid: TileMapLayer = $Background/Solid

var objects : Dictionary # Objects are sparse so we're using a dictionary

var width : int
var height : int

const OCCUPIED = -2.0
const OBSTACLE = -3.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	width = background.get_used_rect().size.x
	height = background.get_used_rect().size.y

func get_layout() -> Array:
	var grid = Utility.get_2d_array(width, height, -1.0)
	
	for x in range(width):
		for y in range(height):
			if is_occupied(Vector2i(x, y)):
				grid[y][x] = OCCUPIED
				continue
			else:
				if is_solid(Vector2i(x, y)):
					grid[y][x] = OBSTACLE
	return grid
	
func get_pos(pos: Vector2) -> Vector2i:
	return background.local_to_map(background.to_local(pos))
	
func is_solid(pos: Vector2i):
	return solid.get_cell_atlas_coords(pos) != Vector2i(-1, -1)
	
func is_occupied(pos: Vector2i):
	return pos in objects.keys() 
	
func snap_to(pos: Vector2i) -> Vector2:
	return background.to_global(background.map_to_local(pos))
	
func manhattan_radius(radius: int, center: Vector2i = Vector2i(0, 0)):
	var neighborhood = []
	for i in range(-radius, radius+1):
		for j in range(-radius, radius+1):
			neighborhood.append(Vector2i(i, j) + center)
	return neighborhood
		
func euclidean_radius(radius: float, center: Vector2i = Vector2i(0, 0)):
	var neighborhood = []
	for i in range(-radius, radius+1):
		for j in range(-radius, radius+1):
			if (Vector2(i, j).length() <= radius):
				neighborhood.append(Vector2i(i, j) + center)
	return neighborhood
			
func diamond_radius(radius: int, center: Vector2i = Vector2i(0, 0)):
	var neighborhood = []
	for i in range(-radius, radius+1):
		for j in range(-radius+abs(i), radius-abs(i)+1):
			neighborhood.append(Vector2i(i, j) + center)
	return neighborhood
