extends RayCast3D
## Camera-aligned detection only; use actions and interactable semantics begin in Phase 3.
signal target_changed(target: CollisionObject3D)

@export_range(0.1, 20.0, 0.1) var reach: float = 3.0:
	set(value):
		reach = value
		target_position = Vector3(0.0, 0.0, -reach)

var current_target: CollisionObject3D

func _ready() -> void:
	target_position = Vector3(0.0, 0.0, -reach)
	var ancestor := get_parent()
	while ancestor != null:
		if ancestor is CollisionObject3D:
			add_exception(ancestor as CollisionObject3D)
			break
		ancestor = ancestor.get_parent()

func _physics_process(_delta: float) -> void:
	var next_target := get_collider() as CollisionObject3D
	if next_target != current_target:
		current_target = next_target
		target_changed.emit(current_target)
