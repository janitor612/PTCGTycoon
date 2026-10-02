extends Node
## Applies captured mouse motion to a yaw body and a separate pitch pivot.

@export var yaw_body_path: NodePath
@export var pitch_pivot_path: NodePath
@export_range(0.01, 1.0, 0.01) var sensitivity_degrees: float = 0.12
@export_range(-89.0, -1.0, 1.0) var minimum_pitch_degrees: float = -85.0
@export_range(1.0, 89.0, 1.0) var maximum_pitch_degrees: float = 85.0

@onready var yaw_body: Node3D = get_node(yaw_body_path)
@onready var pitch_pivot: Node3D = get_node(pitch_pivot_path)
var pitch_radians: float = 0.0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	GameManager.state_changed.connect(_on_game_state_changed)
	_apply_mouse_mode(GameManager.state)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and GameManager.state == GameManager.State.RUNNING:
		var motion := event as InputEventMouseMotion
		var sensitivity := deg_to_rad(sensitivity_degrees)
		yaw_body.rotate_y(-motion.relative.x * sensitivity)
		pitch_radians = clampf(pitch_radians - motion.relative.y * sensitivity, deg_to_rad(minimum_pitch_degrees), deg_to_rad(maximum_pitch_degrees))
		pitch_pivot.rotation.x = pitch_radians
		get_viewport().set_input_as_handled()

func _on_game_state_changed(_previous: GameManager.State, current: GameManager.State) -> void:
	_apply_mouse_mode(current)

func _apply_mouse_mode(state: GameManager.State) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if state == GameManager.State.RUNNING else Input.MOUSE_MODE_VISIBLE
