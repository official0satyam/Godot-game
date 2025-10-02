extends Control

signal look_delta(delta: Vector2)

var dragging := false
var last_pos := Vector2.ZERO

func _gui_input(event):
	if event is InputEventScreenDrag:
		emit_signal("look_delta", event.relative)
