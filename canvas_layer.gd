extends CanvasLayer

@onready var panel: Panel = $Panel
@onready var label: Label = $Panel/Label

func _ready():
	panel.visible = false
	add_to_group("UI")  # so teacher can call it

func show_teacher_message(msg: String):
	label.text = msg
	panel.visible = true

func hide_teacher_message():
	panel.visible = false
