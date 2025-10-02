extends Button

@onready var pause_panel = $"../../pause panel"
@onready var sound = $"../../uisound"

func _pressed():
	sound.play()
	if pause_panel.is_open:
		pause_panel.hide_pause()
	else:
		pause_panel.show_pause()
