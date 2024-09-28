extends Node
class_name Input_manager

signal up
signal left
signal down
signal right

@export var cooldown_duration = 0.1
var cooldowns = {
	"up": 0.0,
	"left": 0.0,
	"down": 0.0,
	"right": 0.0
}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for cd_key in cooldowns.keys():
		cooldowns[cd_key] -= delta
		if cooldowns[cd_key] < 0.0:
			cooldowns[cd_key] = 0.0
	
func _input(event: InputEvent) -> void:
	if event.is_action("ui_up") and cooldowns["up"] == 0.0:
		cooldowns["up"] = cooldown_duration
		print("up")
		up.emit()
	if event.is_action("ui_left") and cooldowns["left"] == 0.0:
		cooldowns["left"] = cooldown_duration
		left.emit()
		print("left")
	if event.is_action("ui_down") and cooldowns["down"] == 0.0:
		cooldowns["down"] = cooldown_duration
		down.emit()
		print("down")
	if event.is_action("ui_right") and cooldowns["right"] == 0.0:
		cooldowns["right"] = cooldown_duration
		right.emit()
		print("right")
