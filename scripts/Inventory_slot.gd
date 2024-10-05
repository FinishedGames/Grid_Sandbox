extends Control

@onready var drop_zone : Drop_zone = $".."
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	drop_zone.on_dropped.connect(on_drop)

func on_drop(draggable : Node2D, pos: Vector2):
	draggable.position = drop_zone.position
	print("dropped")
