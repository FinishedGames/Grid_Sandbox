extends Area2D
class_name Draggable

@export var dnd_manager : Drag_n_drop_manager

func _ready() -> void:
	input_event.connect(_input_event)
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		dnd_manager.dragged = self
		dnd_manager.dragged_prev_pos = position
		
