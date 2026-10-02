extends Node3D

@onready var player: CharacterBody3D = $FirstPersonPlayer
@onready var player_spawn: Marker3D = $TestEnvironment/PlayerSpawn

func _ready() -> void:
	player.global_transform = player_spawn.global_transform
	$FirstPersonPlayer/InteractionController.prompt_changed.connect($FoundationHUD.set_interaction_prompt)
	GameManager.start_session()



