extends Node

const PLAYER_SCENE := preload("res://scenes/player/first_person_player.tscn")
const ENVIRONMENT_SCENE := preload("res://scenes/world/test_environment.tscn")
var failures: int = 0
var player: CharacterBody3D

func _ready() -> void:
	GameManager.start_session()
	var environment := ENVIRONMENT_SCENE.instantiate()
	add_child(environment)
	player = PLAYER_SCENE.instantiate()
	add_child(player)
	player.global_position = Vector3(0.0, 0.9, 1.5)
	await _physics_frames(3)
	_check(player.is_on_floor(), "Player settles on the floor")
	_check(player.get_interaction_target() != null, "Interaction ray detects the crate")
	_check(player.get_interaction_target() != player, "Interaction ray excludes its player body")

	Input.action_press("move_forward")
	await _physics_frames(45)
	Input.action_release("move_forward")
	_check(player.global_position.z > -0.6, "Crate collision blocks forward movement")

	player.global_position = Vector3(0.0, 0.9, 3.0)
	player.velocity = Vector3.ZERO
	Input.action_press("move_left")
	Input.action_press("move_backward")
	await _physics_frames(30)
	var diagonal_speed := Vector2(player.velocity.x, player.velocity.z).length()
	Input.action_release("move_left")
	Input.action_release("move_backward")
	_check(diagonal_speed <= player.walk_speed + 0.05, "Diagonal movement is normalized")

	Input.action_press("move_right")
	Input.action_press("sprint")
	await _physics_frames(30)
	var sprint_speed := Vector2(player.velocity.x, player.velocity.z).length()
	Input.action_release("move_right")
	Input.action_release("sprint")
	_check(sprint_speed > player.walk_speed, "Sprint increases movement speed")

	var paused_position := player.global_position
	GameManager.toggle_pause()
	Input.action_press("move_forward")
	await _physics_frames(5)
	Input.action_release("move_forward")
	_check(player.global_position.is_equal_approx(paused_position), "Pause stops player movement")
	_check(Input.mouse_mode == Input.MOUSE_MODE_VISIBLE, "Pause releases the mouse")
	GameManager.toggle_pause()

	print("Phase 2 smoke test: %s failures" % failures)
	get_tree().quit(failures)

func _physics_frames(count: int) -> void:
	for _index in count:
		await get_tree().physics_frame

func _check(condition: bool, description: String) -> void:
	if not condition:
		failures += 1
		push_error(description)
