extends Node2D
class_name Grid_actor

@onready var grid : Grid_manager = %Grid
@export var speed = 1.0 # tiles_per_second
@export var tile_size = 16

var _move_progress = 0.0
var _move_duration = 1.0

# movement state
var moving_to = null
var _moving_from = null # the tile from which movement was started, used to interpolate

var _is_moving = false
var _halfway_done = false
var _step_success = true
signal _move_end

@export var can_pass_objects = false
@export var can_pass_solids = false

var placeholder = "moved to" # placeholder to pre-occupy tiles to which the agent moves

func step(delta: Vector2i, callback = null):
	if moving_to == null:
		if callback != null:
			_move_end.connect(callback)
		_moving_from = grid.get_pos(position)
		moving_to = _moving_from + delta
		
func step_to(pos: Vector2i, callback = null):
	step(pos - get_grid_pos(), callback)
		
func get_grid_pos() -> Vector2i:
	return grid.get_pos(position)

func _ready() -> void:
	# attach self to nearest tile
	var grid_pos = get_grid_pos()
	position = grid.snap_to(grid_pos)
	grid.objects[grid_pos] = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if moving_to and not _is_moving:
		# regenerate route if target tile is occupied.
		var _debug = grid.is_occupied(get_grid_pos())
		var next_is_occupied = grid.is_occupied(moving_to)
		var next_is_solid = grid.is_solid(moving_to)

		if (not next_is_occupied or can_pass_objects) and \
		   (not next_is_solid or can_pass_solids):
			_begin_step() # next step vacant, begin movement
		else:
			_step_success = false
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
			position = grid.snap_to(get_grid_pos()) # snap position to grid
			_step_success = true
			_end_step()
	
func _begin_step():
	# pre-occupy tile with placeholder
	grid.objects[moving_to] = placeholder
	_moving_from = get_grid_pos()
	_move_duration = (grid.snap_to(_moving_from) - 
					  grid.snap_to(moving_to)).length() / speed / tile_size
	_is_moving = true
	
func _step_halfway():
	grid.objects.erase(_moving_from)
	grid.objects[moving_to] = self
		
func _end_step():
	var connections = _move_end.get_connections()
	_move_progress = 0.0
	moving_to = null
	_moving_from = null
	_is_moving = false
	
	for connection in connections:
		var callable = connection["callable"]
		_move_end.disconnect(callable)
		callable.call(_step_success)
	connections = _move_end.get_connections()	
