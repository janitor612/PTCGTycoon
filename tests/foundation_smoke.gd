extends Node
var failures: int = 0
const TEST_PATH := "user://foundation_test.json"

func _ready() -> void:
	GameManager.start_session()
	_check(GameManager.state == GameManager.State.RUNNING, "Startup state")
	GameManager.toggle_pause()
	_check(get_tree().paused, "Pause")
	GameManager.toggle_pause()
	_check(not get_tree().paused, "Resume")
	for action in ["move_forward", "move_backward", "move_left", "move_right", "sprint", "interact", "pause", "debug_toggle", "primary_interaction", "secondary_interaction", "rotate_left", "rotate_right", "inspect_zoom_in", "inspect_zoom_out"]:
		_check(InputMap.has_action(action), "Input: " + action)
	var payload := {"foundation_marker": "round_trip", "settings": {"volume": 0.75}}
	_check(SaveManager.save_payload(payload, TEST_PATH) == OK, "First save")
	_check(SaveManager.save_payload(payload, TEST_PATH) == OK, "Backup rotation")
	_check(FileAccess.file_exists(TEST_PATH + ".bak"), "Backup exists")
	_check(SaveManager.load_payload(TEST_PATH) == payload, "Round trip")
	var file := FileAccess.open(TEST_PATH, FileAccess.WRITE)
	file.store_string('{"version":999,"payload":{}}')
	file.close()
	_check(SaveManager.load_payload(TEST_PATH).is_empty(), "Future version rejected")
	file = FileAccess.open(TEST_PATH, FileAccess.WRITE)
	file.store_string('invalid json')
	file.close()
	_check(SaveManager.load_payload(TEST_PATH).is_empty(), "Malformed JSON rejected")
	for suffix in ["", ".bak", ".tmp"]:
		if FileAccess.file_exists(TEST_PATH + suffix):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(TEST_PATH + suffix))
	print("Foundation smoke test: %s failures" % failures)
	get_tree().quit(failures)

func _check(condition: bool, description: String) -> void:
	if not condition:
		failures += 1
		push_error(description)
