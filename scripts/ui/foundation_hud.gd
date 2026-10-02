extends CanvasLayer
@onready var debug_label: Label = $DebugPanel/DebugLabel
@onready var debug_panel: PanelContainer = $DebugPanel
@onready var pause_label: Label = $PauseLabel
var refresh_remaining: float = 0.0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	DebugManager.visibility_changed.connect(_on_debug_visibility_changed)
	GameManager.state_changed.connect(_on_state_changed)
	debug_panel.visible = DebugManager.is_visible
	pause_label.visible = GameManager.state == GameManager.State.PAUSED

func _process(delta: float) -> void:
	if not debug_panel.visible:
		return
	refresh_remaining -= delta
	if refresh_remaining <= 0.0:
		refresh_remaining = 0.25
		var snapshot := DebugManager.get_snapshot()
		var position_text: String = str(snapshot.get("player_position", "Unavailable"))
		var target_text: String = str(snapshot.get("raycast_target", "None"))
		debug_label.text = "DEBUG • PHASE 4\nFPS: %s\nState: %s\nNodes: %s\nGodot: %s\nPlayer: %s\nRay target: %s" % [snapshot.fps, snapshot.state, snapshot.nodes, snapshot.engine, position_text, target_text]

func _on_debug_visibility_changed(is_visible: bool) -> void:
	debug_panel.visible = is_visible
	refresh_remaining = 0.0

func _on_state_changed(_previous: GameManager.State, current: GameManager.State) -> void:
	pause_label.visible = current == GameManager.State.PAUSED

func set_interaction_prompt(text: String) -> void:
	$InteractionPrompt.text = text
	$Crosshair.modulate = Color(0.3, 0.85, 1.0) if not text.is_empty() else Color.WHITE

