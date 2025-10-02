extends Node

# === Nodes ===
@onready var player: CharacterBody3D = get_node("../CharacterBody3D")
@onready var panel: Panel = get_node("../CanvasLayer/Panel")
@onready var label: Label = panel.get_node("Label")
@onready var start_task_button: Button = get_node("../CanvasLayer/StartTaskButton")

@onready var class_enter: Area3D = get_node("../class enter")
@onready var desk: Area3D = get_node("../desk")

@export var teacher: CharacterBody3D
@export var student: CharacterBody3D

# Animation Players
@onready var teacher_anim: AnimationPlayer = get_node("../math teacher/68ccb826ea5356727b0239eb/Armature/AnimationPlayer")
@export var student_anim: AnimationPlayer

@onready var audio_player: AudioStreamPlayer = AudioStreamPlayer.new()

var mission_stage: int = 0
var class_triggered := false
var desk_triggered := false
var inside_desk := false

# === Mission 1 dialogue (now with speakers) ===
var teacher_dialogues = [
	{"speaker":"teacher", "text": "Welcome to math class, today we’ll begin with basics.", "voice": "res://audio/teacher1.ogg"},
	{"speaker":"student", "text": "Good morning, sir!", "voice": "res://audio/student1.ogg"},
	{"speaker":"teacher", "text": "Sit down on your desk and get ready.", "voice": "res://audio/teacher2.ogg"},
	{"speaker":"player", "text": "Okay sir.", "voice": ""},
]

func _ready() -> void:
	panel.visible = false
	start_task_button.visible = false
	add_child(audio_player)

	if class_enter:
		class_enter.body_entered.connect(_on_class_entered)
	if desk:
		desk.body_entered.connect(_on_desk_entered)
		desk.body_exited.connect(_on_desk_exited)

	start_task_button.pressed.connect(_on_start_task_button_pressed)

	mission_stage = 0
	show_message("Mission: Go to your class.","")

# === Mission 1 triggers ===
func _on_class_entered(body: Node) -> void:
	if body == player and mission_stage == 0 and not class_triggered:
		class_triggered = true
		mission_stage = 1
		start_cutscene()

func _on_desk_entered(body: Node) -> void:
	if body != player:
		return

	# Mission 1 complete
	if mission_stage == 2 and not desk_triggered:
		desk_triggered = true
		mission_stage = 3
		show_message("Mission Complete! You sat at your desk.","")
		await get_tree().create_timer(3.0).timeout
		hide_message()

		# Enable Mission 2
		mission_stage = 4
		show_message("Go to your desk for next task.","")

	# Mission 2 desk trigger
	elif mission_stage == 4:
		inside_desk = true
		show_message("Press E or click Start Task to begin Mission 2.","")
		start_task_button.visible = true

func _on_desk_exited(body: Node) -> void:
	if body == player and mission_stage == 4:
		inside_desk = false
		start_task_button.visible = false
		show_message("Go to your desk for next task.","")

# === Mission 1 cutscene ===
func start_cutscene() -> void:
	player.set_physics_process(false)
	if teacher:
		player.look_at(teacher.global_transform.origin, Vector3.UP)
	await play_dialogues(teacher_dialogues)
	mission_stage = 2
	player.set_physics_process(true)
	show_message("Mission: Go and sit at your desk.", "")

# === Dialogue player with speaker-aware animations ===
func play_dialogues(dialogues: Array) -> void:
	for d in dialogues:
		show_message(d["text"], d.get("voice",""))

		# Play animations based on speaker
		match d.get("speaker",""):
			"teacher":
				if teacher_anim:
					teacher_anim.play("talk/mixamo_com")
			"student":
				if student_anim:
					student_anim.play("")
			_: # player or unknown → no animation
				pass

		# Wait for audio or fallback
		if audio_player.stream:
			audio_player.play()
			await audio_player.finished
		else:
			await get_tree().create_timer(2.5).timeout

		# Reset speaker animations
		match d.get("speaker",""):
			"teacher":
				if teacher_anim:
					teacher_anim.play("stand/mixamo_com")
			"student":
				if student_anim:
					student_anim.play("")
			_:
				pass

		hide_message()

# === UI text + voice ===
func show_message(text: String, audio_path: String="") -> void:
	panel.visible = true
	label.text = text
	if audio_path != "":
		var stream = load(audio_path)
		if stream:
			audio_player.stream = stream
			audio_player.play()

func hide_message() -> void:
	panel.visible = false
	label.text = ""

# === Mission 2 triggers ===
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if mission_stage == 4 and inside_desk and Input.is_action_just_pressed("ui_accept"):
		start_mission_2()

func _on_start_task_button_pressed() -> void:
	if mission_stage == 4 and inside_desk:
		start_mission_2()

# === Mission 2 ===
func start_mission_2():
	start_task_button.visible = false
	hide_message()
	mission_stage = 5

	player.set_physics_process(false)
	if teacher:
		player.look_at(teacher.global_transform.origin, Vector3.UP)

	show_message("Math Teacher: आज हम कुछ सवाल करेंगे!", "res://audio/teacher3.ogg")
	await get_tree().create_timer(3.0).timeout
	hide_message()

	var quiz_panel = get_node("../CanvasLayer/QuizPanel")
	if quiz_panel:
		quiz_panel.start_quiz(self)

func on_quiz_pass():
	show_message("Math Teacher: बहुत अच्छा! मिशन पूरा हुआ.","res://audio/teacher_success.ogg")
	mission_stage = 6
	await get_tree().create_timer(3.0).timeout
	hide_message()
	player.set_physics_process(true)

func on_quiz_fail():
	show_message("Math Teacher: गलत जवाब! फिर से कोशिश करो.","res://audio/teacher_fail.ogg")
	await get_tree().create_timer(3.0).timeout
	hide_message()
	var quiz_panel = get_node("../CanvasLayer/QuizPanel")
	if quiz_panel:
		quiz_panel.start_quiz(self)
