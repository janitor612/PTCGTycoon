extends Node
## Coordinates lifecycle only; gameplay belongs to dedicated systems.
signal state_changed(previous: State, current: State)
enum State { BOOTING, RUNNING, PAUSED }
var state: State = State.BOOTING

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func start_session() -> void:
	_set_state(State.RUNNING)

func toggle_pause() -> void:
	if state == State.RUNNING:
		_set_state(State.PAUSED)
	elif state == State.PAUSED:
		_set_state(State.RUNNING)

func _set_state(next_state: State) -> void:
	if state == next_state:
		return
	var previous := state
	state = next_state
	get_tree().paused = state == State.PAUSED
	state_changed.emit(previous, state)
