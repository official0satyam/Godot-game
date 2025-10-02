extends CharacterBody3D

@export var speed: float = 5.0
@export var gravity: float = 9.8
@export var jump_force: float = 5.0
@export var look_sensitivity: float = 0.3

var y_velocity: float = 0.0
@onready var camera: Camera3D = $CollisionShape3D/head/Camera3D

# Mobile controls (joystick + look area)
@onready var joystick := get_node("/Main/CanvasLayer/Virtual Joystick")
@onready var look_area := $"../CanvasLayer/Control/LookArea" # if you added one for camera swipe

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if look_area:
		look_area.connect("look_delta", Callable(self, "_on_look_delta"))
		
	var class_enter = get_node_or_null("/root/Main/World/ClassEnter")
	if class_enter:
		class_enter.connect("body_entered", Callable(self, "_on_class_entered"))

	# Connect to the desk trigger if it exists
	var desk = get_node_or_null("/root/Main/World/Desk")
	if desk:
		desk.connect("body_entered", Callable(self, "_on_desk_entered"))

func _physics_process(delta):
	# --- Apply gravity ---
	if not is_on_floor():
		y_velocity -= gravity * delta
	else:
		y_velocity = 0
		if Input.is_action_just_pressed("jump"): # Space or touch for jump
			y_velocity = jump_force

	# --- Movement (joystick or keyboard fallback) ---
	var input_dir = Vector2.ZERO
	if joystick:
		input_dir = joystick.get_vector()
	else:
		input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	var forward = transform.basis.z
	var right = transform.basis.x
	var move_dir = (right * input_dir.x + forward * input_dir.y).normalized()

	velocity.x = move_dir.x * speed
	velocity.z = move_dir.z * speed
	velocity.y = y_velocity

	move_and_slide()

func _on_look_delta(delta: Vector2) -> void:
	rotate_y(-delta.x * look_sensitivity * 0.01)
	camera.rotate_x(-delta.y * look_sensitivity * 0.01)
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -80, 80)
	
	


# When player enters class
func _on_class_entered(body):
	if body == self:
		print("Entered the classroom – start dialogue here")
		# TODO: later we’ll pause movement & show dialogue panel

# When player reaches desk
func _on_desk_entered(body):
	if body == self:
		print("Player reached desk – update mission here")
		# TODO: later we’ll show “Mission Complete” or continue
					

	
