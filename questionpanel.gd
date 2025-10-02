extends Panel

@onready var question_label = $QuestionLabel
@onready var option_buttons = [$Option1, $Option2, $Option3, $Option4]
@onready var next_button = $NextButton

var questions = [
	{"q": "2 + 2 = ?", "options": ["3", "4", "5", "6"], "answer": 1},
	{"q": "5 × 3 = ?", "options": ["8", "15", "10", "12"], "answer": 1},
	{"q": "12 ÷ 4 = ?", "options": ["2", "4", "3", "5"], "answer": 2},
	{"q": "7 + 6 = ?", "options": ["12", "13", "14", "11"], "answer": 1},
	{"q": "9 − 5 = ?", "options": ["2", "5", "4", "3"], "answer": 2}
]

var current_question = 0
var correct_count = 0
var selected = -1
var mission_manager = null

func _ready():
	hide()
	for i in range(option_buttons.size()):
		option_buttons[i].pressed.connect(_on_option_pressed.bind(i))
	next_button.pressed.connect(_on_next_pressed)

func start_quiz(manager):
	mission_manager = manager
	current_question = 0
	correct_count = 0
	selected = -1
	show_question()
	show()

func show_question():
	var q = questions[current_question]
	question_label.text = q.q
	for i in range(option_buttons.size()):
		option_buttons[i].text = q.options[i]
	selected = -1

func _on_option_pressed(index):
	selected = index

func _on_next_pressed():
	if selected == -1:
		return
	if selected == questions[current_question].answer:
		correct_count += 1
	current_question += 1
	if current_question < questions.size():
		show_question()
	else:
		finish_quiz()

func finish_quiz():
	hide()
	if correct_count >= 3:
		mission_manager.on_quiz_pass()
	else:
		mission_manager.on_quiz_fail()
