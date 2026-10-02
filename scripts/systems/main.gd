extends Node3D

func _ready() -> void:
	GameManager.start_session()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		GameManager.toggle_pause()
		get_viewport().set_input_as_handled()
