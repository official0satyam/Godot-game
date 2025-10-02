extends Panel

@onready var overlay = $"../ColorRect"
@onready var resume_btn = $VBoxContainer/Resume
@onready var settings_btn = $VBoxContainer/Settings
@onready var quit_btn = $VBoxContainer/Quit
@onready var click_sound = $"../uisound"

#@onready var settings2 = preload("res://Settings.tscn").instantiate()


var is_open = false
var original_pos : Vector2

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	overlay.process_mode = Node.PROCESS_MODE_ALWAYS
	resume_btn.process_mode = Node.PROCESS_MODE_ALWAYS
	settings_btn.process_mode = Node.PROCESS_MODE_ALWAYS
	quit_btn.process_mode = Node.PROCESS_MODE_ALWAYS

	original_pos = position
	position.x = get_viewport_rect().size.x   # start hidden off-screen
	visible = false
	overlay.visible = false
	overlay.modulate.a = 0.0

	resume_btn.pressed.connect(_on_resume_pressed)
	settings_btn.pressed.connect(_on_settings_pressed)
	quit_btn.pressed.connect(_on_quit_pressed)

func show_pause():
	if is_open: return
	is_open = true
	visible = true
	overlay.visible = true
	get_tree().paused = true

	var tween = create_tween()
	tween.tween_property(self, "position:x", original_pos.x, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(overlay, "modulate:a", 0.5, 0.4)

func hide_pause():
	if not is_open: return
	is_open = false

	var tween = create_tween()
	tween.tween_property(self, "position:x", get_viewport_rect().size.x, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(overlay, "modulate:a", 0.0, 0.3)
	tween.finished.connect(func():
		visible = false
		overlay.visible = false
	)
	get_tree().paused = false

func _on_resume_pressed():
	click_sound.play()
	hide_pause()

func _on_settings_pressed():
	click_sound.play()
	#hide_pause()
	get_tree().paused = false  # allow UI to work
	$"../Settings".visible = true

func _on_quit_pressed():
	click_sound.play()
	hide_pause()
	get_tree().change_scene_to_file("res://main_menu.tscn")
