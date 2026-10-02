extends Node3D

@onready var player: CharacterBody3D = $FirstPersonPlayer
@onready var player_spawn: Marker3D = $TestEnvironment/PlayerSpawn

func _ready() -> void:
	player.global_transform = player_spawn.global_transform
	GameManager.start_session()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		GameManager.toggle_pause()
		get_viewport().set_input_as_handled()
