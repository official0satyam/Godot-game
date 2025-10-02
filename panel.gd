# panel.gd (attach to CanvasLayer/Panel)
extends Panel

@onready var label: Label = $Label
# find player (Panel -> CanvasLayer -> Main sibling CharacterBody3D => "../../CharacterBody3D")
@onready var player_ref = get_node_or_null("../../CharacterBody3D")

func _ready():
	visible = false

# Show text and optionally freeze player for duration; this is awaitable
func show_and_wait(text: String, freeze: bool = false, duration: float = 2.5) -> void:
	label.text = text
	visible = true
	if freeze and player_ref:
		if player_ref.has_method("freeze_player"):
			player_ref.freeze_player()
		else:
			player_ref.set_process(false)
			player_ref.set_physics_process(false)

	# wait
	await get_tree().create_timer(duration).timeout

	# hide and unfreeze if needed
	visible = false
	if freeze and player_ref:
		if player_ref.has_method("unfreeze_player"):
			player_ref.unfreeze_player()
		else:
			player_ref.set_process(true)
			player_ref.set_physics_process(true)
