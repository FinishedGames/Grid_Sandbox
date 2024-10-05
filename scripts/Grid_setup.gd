extends Node

@onready var grid : Grid_manager = %Grid
@export var seed = 1111

func _ready() -> void:
	seed(seed)
	var size = grid.background.get_used_rect()
	for x in range(size.size.x):
		for y in range(size.size.y):
			var random = randf()
			var tile_option
			if random < 0.08:
				if random < 0.03:
					tile_option = Vector2i(2, 0)
				else:
					tile_option = Vector2i(1, 0)
			else:
				tile_option = Vector2i(0, 0)
			grid.background.set_cell(Vector2i(size.position.x + x, size.position.y + y), 0, tile_option)
		
	
