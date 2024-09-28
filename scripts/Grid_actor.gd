extends Node2D
class_name Grid_actor

@export var grid : Grid_manager
@export var speed = 1.0 # tiles_per_second

var _move_progress = 0.0
var _move_duration = 1.0

# movement state
var moving_to = null
var _moving_from = null # the tile from which movement was started, used to interpolate

var _is_moving = false
var _halfway_done = false
var _move_end_callback = null

@export var can_pass_objects = false
@export var can_pass_solids = false

var tile_occupier = "moved to" # placeholder to pre-occupy tiles to which the agent moves

func _ready() -> void:
	# attach self to nearest tile
	var grid_pos = grid.get_pos(position)
	position = grid.snap_to(grid_pos)
	grid.objects[grid_pos.y][grid_pos.x] = self
	
func step(delta: Vector2i, callback = null):
	if moving_to == null:
		_move_end_callback = callback
		_moving_from = grid.get_pos(position)
		moving_to = _moving_from + delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if moving_to and not _is_moving:
		# regenerate route if target tile is occupied.
		var next_is_occupied = grid.is_occupied(moving_to)
		var next_is_solid = grid.is_solid(moving_to)

		if (not next_is_occupied or can_pass_objects) and \
		   (not next_is_solid or can_pass_solids):
			_begin_step() # next step vacant, begin movement
		else:
			_end_step() # occupied, can't move
			
	if _is_moving:
		# remove tile_occupier and hop to next tile when movement is halfway done
		if not _halfway_done and _move_progress + delta >= _move_duration * 0.5:
			_step_halfway()
				
		if _move_progress < _move_duration - delta:
			# Movement not about to finish
			var progress_norm = _move_progress / _move_duration
			position = lerp(grid.snap_to(_moving_from), 
							grid.snap_to(moving_to), 
							progress_norm ** 2 * 2 if progress_norm < 0.5 else 1 - 2*(1 - progress_norm) ** 2)
			_move_progress += delta
		else: # finishing step
			position = grid.snap_to(grid.get_pos(position)) # snap position to grid
			_end_step()
	
func _begin_step():
	# pre-occupy tile with placeholder
	grid.objects[moving_to.y][moving_to.x] = tile_occupier
	_moving_from = grid.get_pos(position)
	_move_duration = (grid.snap_to(_moving_from) - 
					  grid.snap_to(moving_to)).length() / speed
	_is_moving = true
	
func _step_halfway():
	grid.objects[_moving_from.y][_moving_from.x] = null # unoccupy previous tile
	grid.objects[moving_to.y][moving_to.x] = self # move self to next tile 
		
func _end_step():
	if _move_end_callback:
		_move_end_callback.call()
	_move_progress = 0.0
	moving_to = null
	_moving_from = null
	_is_moving = false
	_move_end_callback = null
