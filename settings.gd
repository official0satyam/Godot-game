extends Control

@onready var panel = $Panel
@onready var back_button = $Button
@onready var music_slider = $Panel/GridContainer/HFlowContainer/HSlider
@onready var sfx_slider = $Panel/GridContainer/HFlowContainer2/HSlider
@onready var click_sound = $ClickSound

func _ready():
	back_button.pressed.connect(_on_back_pressed)
	music_slider.value_changed.connect(_on_music_volume_changed)
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)

	# Only hide if this is instanced inside another scene
	if get_tree().current_scene.name != "Control": # replace with your main scene name
		hide()

func show_settings():
	show()
	panel.scale = Vector2(0.8, 0.8)
	panel.modulate.a = 0
	var tween = create_tween()
	tween.tween_property(panel, "scale", Vector2(1, 1), 0.3).set_trans(Tween.TRANS_BOUNCE)
	tween.parallel().tween_property(panel, "modulate:a", 1.0, 0.3)


'''func _on_back_pressed():
	# Detect the previous scene name
	var current_scene = get_tree().current_scene
	if current_scene.name == "main_menu":  
		 # If settings was opened from Main Menu
		get_tree().change_scene_to_file("res://main_menu.tscn")
	elif current_scene.name == "Main":  
		# If settings was opened from in-game Pause Menu
		get_tree().change_scene_to_file("res://Main.tscn")
	else:
		# Fallback (in case scene names are different
		get_tree().change_scene_to_file("res://main_menu.tscn")'''
		


func _on_back_pressed():
	click_sound.play()
	$".".visible = false  # hide settings panel
	
	
	if get_tree().current_scene.name == "Main":
		get_tree().paused = true
	else:
		print("seen nit fou")
		
	
func _on_music_volume_changed(value: float):
	var bus_index = AudioServer.get_bus_index("Music")
	if bus_index != -1:
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(value / 100.0))

func _on_sfx_volume_changed(value: float):
	var bus_index = AudioServer.get_bus_index("SFX")
	if bus_index != -1:
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(value / 100.0))


func _back_pressed() -> void:
	pass # Replace with function body.
