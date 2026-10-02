extends Node
var failures: int = 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	var main := preload("res://scenes/main.tscn").instantiate()
	add_child(main)
	var player: CharacterBody3D = main.get_node("FirstPersonPlayer")
	var handler: Node3D = player.get_node("ObjectHandling")
	var item: CarryableComponent = main.get_node("TestEnvironment/TestParcelA/CarryableComponent")
	var other: CarryableComponent = main.get_node("TestEnvironment/TestParcelB/CarryableComponent")
	await _frames(3)
	_check(handler.try_pickup(item), "Pickup accepted within reach")
	_check(item.body.freeze and item.is_held, "Carried body frozen")
	_check(not handler.try_pickup(other), "Cannot hold two bodies")
	var before: Vector3 = item.body.position
	await _frames(30)
	_check(item.body.position.distance_to(before) > 0.1, "Carry follows smoothly")
	handler.rotate_held(PI / 2.0)
	_check(is_equal_approx(handler.yaw_offset, PI / 2.0), "Rotation updates")
	GameManager.toggle_pause()
	var paused: Transform3D = item.body.global_transform
	await _frames(4)
	_check(item.body.global_transform == paused, "Pause freezes carried motion")
	_check(not handler.drop(), "Paused drop blocked")
	GameManager.toggle_pause()
	player.get_node("LookPivot").rotation.x = -0.65
	_check(handler.begin_placement(), "Placement preview starts")
	await _frames(3)
	_check(handler.placement_valid, "Floor placement valid")
	_check(handler.confirm_placement(), "Place accepted")
	_check(not item.is_held and not item.body.freeze, "Placement restores physics")
	await _frames(3)
	_check(handler.try_pickup(item), "Placed body can be picked up again")
	player.get_node("LookPivot").rotation.x = 0.0
	player.position = Vector3(-1.4, 0.9, 4.3)
	player.rotation.y = PI
	await _frames(4)
	handler.begin_placement()
	await _frames(2)
	_check(not handler.placement_valid, "Vertical wall placement rejected")
	_check(not handler.confirm_placement(), "Invalid confirmation rejected")
	handler.placement_mode = false
	player.position = Vector3(0, 0.9, 3)
	player.rotation.y = 0
	await _frames(45)
	_check(handler.drop(), "Drop accepted at clear carry position")
	_check(handler.held == null and not item.is_held, "Drop clears ownership")
	print("Phase 4 smoke test: %s failures" % failures)
	get_tree().quit(failures)

func _frames(count: int) -> void:
	for index in count:
		await get_tree().physics_frame

func _check(condition: bool, description: String) -> void:
	if not condition:
		failures += 1
		push_error(description)
