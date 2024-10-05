extends Node
class_name Drag_n_drop_manager

var dragged = null
var dragged_prev_pos = null
var drop_zone = null

signal on_dropped

func _process(delta: float) -> void:
	if dragged != null:
		var viewport = get_viewport()
		var camera = viewport.get_camera_2d()
		dragged.global_position = camera.to_global(camera.get_local_mouse_position())
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not event.is_pressed() and dragged != null:
		var end_position = dragged.position
		dragged.position = dragged_prev_pos
		
		on_dropped.emit(dragged, end_position)
		if drop_zone != null:
			drop_zone.on_dropped.emit(dragged, end_position)
			
		dragged = null
		drop_zone = null
		
