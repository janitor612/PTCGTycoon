extends Node
signal visibility_changed(is_visible: bool)
var is_visible: bool = false
var snapshot_providers: Dictionary = {}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_toggle"):
		is_visible = not is_visible
		visibility_changed.emit(is_visible)
		get_viewport().set_input_as_handled()

func get_snapshot() -> Dictionary:
	var snapshot := {
		"fps": Engine.get_frames_per_second(),
		"state": GameManager.State.keys()[GameManager.state],
		"nodes": Performance.get_monitor(Performance.OBJECT_NODE_COUNT),
		"engine": Engine.get_version_info().string,
	}
	for provider_name: StringName in snapshot_providers:
		var provider: Callable = snapshot_providers[provider_name]
		if provider.is_valid():
			snapshot.merge(provider.call(), true)
	return snapshot

func register_snapshot_provider(provider_name: StringName, provider: Callable) -> void:
	snapshot_providers[provider_name] = provider

func unregister_snapshot_provider(provider_name: StringName) -> void:
	snapshot_providers.erase(provider_name)
