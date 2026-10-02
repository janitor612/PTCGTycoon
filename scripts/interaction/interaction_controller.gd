extends Node
signal prompt_changed(text: String)
@export var ray_path: NodePath
@export var actor_path: NodePath
var suspended: bool = false
var target: InteractableComponent
@onready var ray: RayCast3D = get_node(ray_path)
@onready var actor: Node = get_node(actor_path)

func _ready() -> void:
	GameManager.state_changed.connect(_on_state_changed)

func _physics_process(_delta: float) -> void:
	refresh_target()

func refresh_target() -> void:
	var next_target: InteractableComponent
	if GameManager.state == GameManager.State.RUNNING and not suspended:
		ray.force_raycast_update()
		var collider := ray.get_collider() as Node
		# Only the nearest collision object can supply an interaction, so walls occlude it.
		if is_instance_valid(collider):
			for child in collider.get_children():
				if child is InteractableComponent and child.enabled:
					next_target = child
					break
	_set_target(next_target)

func _set_target(next_target: InteractableComponent) -> void:
	if target == next_target:
		return
	if is_instance_valid(target):
		target.set_focused(false)
		target.presentation_changed.disconnect(_refresh_prompt)
	target = next_target
	if is_instance_valid(target):
		target.set_focused(true)
		target.presentation_changed.connect(_refresh_prompt)
	_refresh_prompt()

func _refresh_prompt() -> void:
	if is_instance_valid(target) and target.enabled:
		prompt_changed.emit("[E] %s • %s" % [target.action_label, target.display_name])
	else:
		prompt_changed.emit("")

func try_use() -> bool:
	if GameManager.state != GameManager.State.RUNNING:
		return false
	refresh_target()
	return is_instance_valid(target) and target.use(actor)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and not event.is_echo():
		if try_use():
			get_viewport().set_input_as_handled()

func _on_state_changed(_previous: GameManager.State, _current: GameManager.State) -> void:
	_set_target(null)

func _exit_tree() -> void:
	_set_target(null)



