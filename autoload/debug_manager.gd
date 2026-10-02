extends Node
signal visibility_changed(is_visible: bool)
var is_visible: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_toggle"):
		is_visible = not is_visible
		visibility_changed.emit(is_visible)
		get_viewport().set_input_as_handled()

func get_snapshot() -> Dictionary:
	return {
		"fps": Engine.get_frames_per_second(),
		"state": GameManager.State.keys()[GameManager.state],
		"nodes": Performance.get_monitor(Performance.OBJECT_NODE_COUNT),
		"engine": Engine.get_version_info().string,
	}
