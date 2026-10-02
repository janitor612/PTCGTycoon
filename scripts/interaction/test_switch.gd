extends StaticBody3D
## Example object behavior; the reusable component does not know about switches.
@export var switch_name: String = "Test switch"
var active: bool = false
@onready var component: InteractableComponent = $InteractionComponent
@onready var mesh: MeshInstance3D = $Mesh
@onready var label: Label3D = $Label
var surface_material: StandardMaterial3D

func _ready() -> void:
	surface_material = StandardMaterial3D.new()
	surface_material.roughness = 0.7
	mesh.material_override = surface_material
	component.display_name = switch_name
	component.used.connect(_on_used)
	_refresh()

func _on_used(_actor: Node) -> void:
	active = not active
	_refresh()

func _refresh() -> void:
	surface_material.albedo_color = Color(0.15, 0.75, 0.4) if active else Color(0.5, 0.25, 0.65)
	label.text = "%s\n%s" % [switch_name, "ON" if active else "OFF"]
	component.action_label = "Turn off" if active else "Turn on"
	component.presentation_changed.emit()
