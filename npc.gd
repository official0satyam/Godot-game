extends Area3D

@export var dialogue_lines: Array[String] = ["hello"]
@export var audio_files: Array[AudioStream] = []

var current_index: int = 0
var player_in_area: bool = false

@onready var dialogue_label = get_node("../../CanvasLayer/Panel/Label2")
@onready var audio_player = get_node("../../audio npc")

func _ready():
	dialogue_label.text = ""
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "CharacterBody3D":
		player_in_area = true
		show_next_dialogue()

func _on_body_exited(body):
	if body.name == "CharacterBody3D":
		player_in_area = false
		dialogue_label.text = ""

func show_next_dialogue():
	if dialogue_lines.size() == 0:
		return
	
	dialogue_label.text = dialogue_lines[current_index]

	if current_index < audio_files.size():
		audio_player.stream = audio_files[current_index]
		audio_player.play()

	current_index = (current_index + 1) % dialogue_lines.size()
