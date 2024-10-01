extends Node

@export var grid_agent : Grid_actor
@export var input_mgr : Input_manager

@export var cursor : Sprite2D
@export var crosshair : Sprite2D

@export var mob : Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	input_mgr.up.connect(go_up)
	input_mgr.right.connect(go_right)
	input_mgr.down.connect(go_down)
	input_mgr.left.connect(go_left)

func _process(_delta: float) -> void:
	var world_pos = grid_agent.grid.get_global_mouse_position()
	var grid_pos = grid_agent.grid.get_pos(world_pos)
	var player_pos = grid_agent.grid.get_pos(grid_agent.position)
	
	if grid_pos in grid_agent.grid.manhattan_radius(2, player_pos):
		cursor.visible = true
		cursor.global_position = grid_agent.grid.snap_to(grid_pos)
	else:
		cursor.visible = false
	crosshair.global_position = world_pos
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if cursor.visible:
			mob.go_to(grid_agent.grid.get_pos(cursor.position))
		else:
			mob.stop()
			
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func go_up():
	grid_agent.step(Vector2i(0, -1))

func go_right():
	grid_agent.step(Vector2i(1, 0))

func go_down():
	grid_agent.step(Vector2i(0, 1))
	
func go_left():
	grid_agent.step(Vector2i(-1, 0))
	
