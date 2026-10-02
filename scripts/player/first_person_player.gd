extends CharacterBody3D
## Owns locomotion only. Looking and detection are composed child components.

@export_range(0.1, 20.0, 0.1) var walk_speed: float = 4.5
@export_range(1.0, 3.0, 0.05) var sprint_multiplier: float = 1.65
@export_range(0.1, 50.0, 0.1) var acceleration: float = 18.0
@export_range(0.1, 50.0, 0.1) var deceleration: float = 24.0
@export_range(0.1, 100.0, 0.1) var gravity: float = 24.0

@onready var interaction_ray: RayCast3D = $LookPivot/Camera3D/InteractionRay

func _ready() -> void:
	DebugManager.register_snapshot_provider(&"player", _get_debug_snapshot)

func _exit_tree() -> void:
	DebugManager.unregister_snapshot_provider(&"player")

func _physics_process(delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var local_direction := Vector3(input_vector.x, 0.0, input_vector.y)
	# Input.get_vector caps the vector length, so diagonal movement is never faster.
	var world_direction := (global_basis * local_direction)
	world_direction.y = 0.0
	world_direction = world_direction.normalized()
	var speed := walk_speed * (sprint_multiplier if Input.is_action_pressed("sprint") else 1.0)
	var target_velocity := world_direction * speed
	var horizontal_velocity := Vector3(velocity.x, 0.0, velocity.z)
	var rate := acceleration if not world_direction.is_zero_approx() else deceleration
	horizontal_velocity = horizontal_velocity.move_toward(target_velocity, rate * delta)
	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z
	if is_on_floor():
		velocity.y = -0.1
	else:
		velocity.y -= gravity * delta
	move_and_slide()

func get_interaction_target() -> CollisionObject3D:
	return interaction_ray.get_collider() as CollisionObject3D

func _get_debug_snapshot() -> Dictionary:
	var target := get_interaction_target()
	return {
		"player_position": "(%.2f, %.2f, %.2f)" % [global_position.x, global_position.y, global_position.z],
		"raycast_target": target.name if target != null else "None",
	}
