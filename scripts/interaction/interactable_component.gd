class_name InteractableComponent
extends Node
## Attach under a collision object; the action signal belongs to the object's behavior.
signal used(actor: Node)
signal presentation_changed
@export var display_name: String = "Object"
@export var action_label: String = "Use"
@export var highlight_mesh_path: NodePath
@export var enabled: bool = true:
	set(value):
		enabled = value
		presentation_changed.emit()
var focused: bool = false
var original_overlay: Material
var highlight_material: StandardMaterial3D
@onready var highlight_mesh: MeshInstance3D = get_node_or_null(highlight_mesh_path) as MeshInstance3D

func _ready() -> void:
	highlight_material = StandardMaterial3D.new()
	highlight_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	highlight_material.albedo_color = Color(0.3, 0.85, 1.0, 0.25)
	highlight_material.emission_enabled = true
	highlight_material.emission = Color(0.1, 0.5, 0.7)
	highlight_material.emission_energy_multiplier = 0.5

func set_focused(value: bool) -> void:
	if focused == value:
		return
	focused = value
	if is_instance_valid(highlight_mesh):
		if focused:
			original_overlay = highlight_mesh.material_overlay
			highlight_mesh.material_overlay = highlight_material
		else:
			highlight_mesh.material_overlay = original_overlay

func use(actor: Node) -> bool:
	if not enabled or not is_instance_valid(actor):
		return false
	used.emit(actor)
	return true

func _exit_tree() -> void:
	set_focused(false)
