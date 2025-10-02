extends Area3D

@onready var mission_manager = $"../MissionMnanager"

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name == "CharacterBody3D" and mission_manager.mission_stage == 1:
		mission_manager.complete_mission(1)
