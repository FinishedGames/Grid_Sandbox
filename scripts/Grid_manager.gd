extends Node
class_name Grid_manager

var misc = load("res://scripts/Misc_functions.gd").new()

@onready var background : TileMapLayer = $background
@onready var foreground : TileMapLayer = $background/foreground
var objects : Array

var width : int
var height : int

const OCCUPIED = -2.0
const OBSTACLE = -3.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	width = background.get_used_rect().size.x
	height = background.get_used_rect().size.y
	objects = misc.get_2d_array(width, height, null)
	
	# align grids

func get_layout() -> Array:
	var grid = misc.get_2d_array(width, height, -1.0)
	
	for x in range(width):
		for y in range(height):
			if is_occupied(Vector2i(x, y)):
				grid[y][x] = OCCUPIED
				continue
			else:
				if is_solid(Vector2i(x, y)):
					grid[y][x] = OBSTACLE
	return grid
			
func get_tile_specs(atlas_coords: Vector2i):
	var tile_info = tile_defaults.duplicate()
	
	if atlas_coords in tile_overrides.keys():
		for key in tile_defaults.keys():
			if key in tile_overrides[atlas_coords]:
				tile_info[key] = tile_overrides[atlas_coords][key]
	return tile_info
	
func get_pos(pos: Vector2) -> Vector2i:
	return background.local_to_map(background.to_local(pos))
	
func is_solid(pos: Vector2i):
	return foreground.get_cell_atlas_coords(pos) != Vector2i(-1, -1)
	
func is_occupied(pos: Vector2i):
	return objects[pos.y][pos.x] != null
	
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
	
var tile_defaults = {
	"solid": false
}

var tile_overrides = {
	Vector2i(0, 0): {
		"solid": true
					},
	Vector2i(1, 0): {
		"solid": true
		}
}
