extends Area2D
class_name Drop_zone

@export var dnd_manager : Drag_n_drop_manager
signal on_dropped

func _ready() -> void:
	mouse_entered.connect(_mouse_enters)
	mouse_exited.connect(_mouse_exits)
		
func _mouse_enters():
	dnd_manager.drop_zone = self

func _mouse_exits():
	if dnd_manager.drop_zone == self:
		dnd_manager.drop_zone = null
		
