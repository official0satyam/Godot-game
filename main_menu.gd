extends Control

@onready var play_button = $VBoxContainer/Play
@onready var settings_button = $VBoxContainer/Settings
@onready var exit_button = $VBoxContainer/Exit
@onready var click_sound = $ClickSound



func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	#add_child(settings)
	#settings.hide()


func _on_play_pressed() -> void:
	click_sound.play()
	# Replace "GameScene" with your first gameplay scene
	get_tree().change_scene_to_file("res://Main.tscn")

#func _on_settings_pressed() -> void:
	# You can make a Settings.tscn later
	#settings.show_settings()

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_settings_pressed():
	click_sound.play()
	$settings.visible = true
#@onready var settings = preload("res://Settings.tscn").instantiate()
