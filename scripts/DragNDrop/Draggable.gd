extends Control
class_name Draggable

@export var dnd_manager : Drag_n_drop_manager
	
func _gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		print(get_global_rect())
		print(event.global_position * get_viewport().get_camera_2d().zoom)
		dnd_manager.dragged = self
		dnd_manager.dragged_prev_pos = position
		print("pressed")
		
