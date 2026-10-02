extends Node
var failures: int = 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	GameManager.start_session()
	for cycle in 3:
		await _escape()
		_check(get_tree().paused, "Escape pauses cycle %s" % cycle)
		await _escape()
		_check(not get_tree().paused, "Escape resumes cycle %s" % cycle)
	print("Pause input regression: %s failures" % failures)
	get_tree().quit(failures)

func _escape() -> void:
	var event := InputEventKey.new()
	event.physical_keycode = KEY_ESCAPE
	event.pressed = true
	Input.parse_input_event(event)
	await get_tree().process_frame
	event = InputEventKey.new()
	event.physical_keycode = KEY_ESCAPE
	event.pressed = false
	Input.parse_input_event(event)
	await get_tree().process_frame

func _check(condition: bool, description: String) -> void:
	if not condition:
		failures += 1
		push_error(description)
