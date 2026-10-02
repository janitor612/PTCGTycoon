extends Node3D
signal hint_changed(text: String)
@export var camera_path: NodePath
@export var actor_path: NodePath
@export var interaction_controller_path: NodePath
@export var carry_distance: float = 1.65
@export var placement_reach: float = 4.0
var held: CarryableComponent
var placement_mode: bool = false
var placement_valid: bool = false
var placement_transform: Transform3D
var yaw_offset: float = 0.0
var was_frozen: bool = false
var preview: MeshInstance3D
var preview_material: StandardMaterial3D
@onready var camera: Camera3D = get_node(camera_path)
@onready var actor: PhysicsBody3D = get_node(actor_path)
@onready var interaction_controller: Node = get_node(interaction_controller_path)

func _ready() -> void:
	GameManager.state_changed.connect(_on_state_changed)

func try_pickup(item: CarryableComponent) -> bool:
	if GameManager.state != GameManager.State.RUNNING or is_instance_valid(held) or item.is_held:
		return false
	if camera.global_position.distance_to(item.body.global_position) > 3.0:
		return false
	held = item
	was_frozen = held.body.freeze
	held.body.freeze = true
	held.body.linear_velocity = Vector3.ZERO
	held.body.angular_velocity = Vector3.ZERO
	held.body.add_collision_exception_with(actor)
	held.is_held = true
	held.interaction.set_focused(false)
	held.interaction.enabled = false
	interaction_controller.suspended = true
	interaction_controller.refresh_target()
	yaw_offset = 0.0
	_create_preview()
	_refresh_hint()
	return true

func _physics_process(delta: float) -> void:
	if not is_instance_valid(held):
		return
	var desired := Transform3D(Basis(Vector3.UP, actor.global_rotation.y + yaw_offset), camera.global_position - camera.global_basis.z * carry_distance + Vector3(0, -0.25, 0))
	# Sweep the actual item shape to stop at walls; smoothing does not pass through colliders.
	var current := held.body.global_transform
	var next := current.interpolate_with(desired, 1.0 - exp(-12.0 * delta))
	var query := _shape_query(current, false)
	query.motion = next.origin - current.origin
	var fractions := held.body.get_world_3d().direct_space_state.cast_motion(query)
	next.origin = current.origin + query.motion * fractions[0]
	if _is_clear(next, false):
		held.body.global_transform = next
	if placement_mode:
		update_placement()

func _shape_query(transform: Transform3D, include_actor: bool) -> PhysicsShapeQueryParameters3D:
	var query := PhysicsShapeQueryParameters3D.new()
	query.shape = held.collision.shape
	query.transform = transform * held.collision.transform
	query.margin = 0.015
	query.collision_mask = held.body.collision_mask
	query.exclude = [held.body.get_rid()] if include_actor else [held.body.get_rid(), actor.get_rid()]
	return query

func _is_clear(transform: Transform3D, include_actor: bool) -> bool:
	return held.body.get_world_3d().direct_space_state.intersect_shape(_shape_query(transform, include_actor), 1).is_empty()

func update_placement() -> void:
	placement_valid = false
	var start := camera.global_position
	var query := PhysicsRayQueryParameters3D.create(start, start - camera.global_basis.z * placement_reach)
	query.exclude = [actor.get_rid(), held.body.get_rid()]
	query.collision_mask = held.body.collision_mask
	var hit := held.body.get_world_3d().direct_space_state.intersect_ray(query)
	preview.visible = not hit.is_empty()
	if not hit.is_empty():
		placement_transform = Transform3D(Basis(Vector3.UP, actor.global_rotation.y + yaw_offset), hit.position + Vector3.UP * (held.bottom_offset + 0.025))
		placement_valid = hit.normal.dot(Vector3.UP) > 0.9 and _is_clear(placement_transform, true)
		preview.global_transform = placement_transform * held.visual.transform
	preview_material.albedo_color = Color(0.15, 1, 0.4, 0.45) if placement_valid else Color(1, 0.2, 0.2, 0.45)
	_refresh_hint()

func begin_placement() -> bool:
	if not is_instance_valid(held) or GameManager.state != GameManager.State.RUNNING:
		return false
	placement_mode = true
	update_placement()
	return true

func rotate_held(angle: float) -> void:
	if GameManager.state == GameManager.State.RUNNING and is_instance_valid(held):
		yaw_offset += angle

func drop() -> bool:
	if not is_instance_valid(held) or GameManager.state != GameManager.State.RUNNING:
		return false
	if not _is_clear(held.body.global_transform, true):
		return false
	_release()
	return true

func confirm_placement() -> bool:
	if not placement_mode or GameManager.state != GameManager.State.RUNNING:
		return false
	update_placement()
	if not placement_valid:
		return false
	held.body.global_transform = placement_transform
	_release()
	return true

func _release() -> void:
	held.body.remove_collision_exception_with(actor)
	held.body.freeze = was_frozen
	held.is_held = false
	held.interaction.enabled = true
	held = null
	placement_mode = false
	placement_valid = false
	if is_instance_valid(preview):
		preview.queue_free()
	interaction_controller.suspended = false
	hint_changed.emit("")

func _create_preview() -> void:
	preview = MeshInstance3D.new()
	preview.mesh = held.visual.mesh
	preview_material = StandardMaterial3D.new()
	preview_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	preview_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	preview.material_override = preview_material
	add_child(preview)
	preview.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if not is_instance_valid(held) or GameManager.state != GameManager.State.RUNNING:
		return
	var handled := true
	if event.is_action_pressed("rotate_left"):
		rotate_held(-PI / 12.0)
	elif event.is_action_pressed("rotate_right"):
		rotate_held(PI / 12.0)
	elif event.is_action_pressed("primary_interaction"):
		if placement_mode:
			confirm_placement()
		else:
			begin_placement()
	elif event.is_action_pressed("secondary_interaction"):
		if placement_mode:
			placement_mode = false
			preview.visible = false
			_refresh_hint()
		else:
			drop()
	elif event.is_action_pressed("interact") and not event.is_echo():
		drop()
	else:
		handled = false
	if handled:
		get_viewport().set_input_as_handled()

func _refresh_hint() -> void:
	if placement_mode:
		hint_changed.emit("%s • Left click place • Right click cancel • Q/R rotate" % ["Valid position" if placement_valid else "Cannot place here"])
	else:
		hint_changed.emit("Carrying • Left click preview • E / Right click drop • Q/R rotate")

func _on_state_changed(_previous: GameManager.State, state: GameManager.State) -> void:
	if not is_instance_valid(held):
		return
	if state == GameManager.State.PAUSED:
		preview.visible = false
		hint_changed.emit("")
	else:
		_refresh_hint()

func _exit_tree() -> void:
	if is_instance_valid(held):
		held.body.remove_collision_exception_with(actor)
		held.body.freeze = was_frozen
		held.is_held = false
		held.interaction.enabled = true
