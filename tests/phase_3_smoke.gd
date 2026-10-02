extends Node
var failures: int = 0
var last_prompt: String = ""

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	var main := preload("res://scenes/main.tscn").instantiate()
	add_child(main)
	var player: CharacterBody3D = main.get_node("FirstPersonPlayer")
	var controller: Node = player.get_node("InteractionController")
	var prop: StaticBody3D = main.get_node("TestEnvironment/LeftTestSwitch")
	var component: InteractableComponent = prop.get_node("InteractionComponent")
	controller.prompt_changed.connect(func(text: String): last_prompt = text)
	player.position = Vector3(-1.4, 0.9, 2.4)
	await _frames(4)
	_check(controller.target == component, "Detect reusable component")
	_check(component.focused, "Target highlighted")
	_check(last_prompt.contains("Turn on"), "Prompt names available action")
	var use_event := InputEventKey.new()
	use_event.physical_keycode = KEY_E
	use_event.pressed = true
	Input.parse_input_event(use_event)
	await _frames(3)
	_check(prop.active, "Input invokes object behavior")
	_check(last_prompt.contains("Turn off"), "Prompt updates after use")
	GameManager.toggle_pause()
	_check(not component.focused, "Pause clears highlight")
	_check(last_prompt.is_empty(), "Pause clears prompt")
	_check(not controller.try_use(), "Paused interaction rejected")
	GameManager.toggle_pause()
	await _frames(2)
	component.enabled = false
	await _frames(2)
	_check(controller.target == null, "Disabled target excluded")
	component.enabled = true
	player.rotation.y = PI
	await _frames(2)
	_check(controller.target == null, "Looking away clears target")
	player.rotation.y = 0.0
	player.position.z = 4.6
	await _frames(2)
	_check(controller.target == null, "Out-of-reach target excluded")
	print("Phase 3 smoke test: %s failures" % failures)
	get_tree().quit(failures)

func _frames(count: int) -> void:
	for index in count:
		await get_tree().physics_frame

func _check(condition: bool, description: String) -> void:
	if not condition:
		failures += 1
		push_error(description)


