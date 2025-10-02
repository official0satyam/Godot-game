extends TextureButton

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	Input.action_press("jump")   # simulate key press
	await get_tree().process_frame
	Input.action_release("jump")
