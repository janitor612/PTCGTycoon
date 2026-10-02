class_name CarryableComponent
extends Node
## Physical data stays on the body; this component connects it to generic interaction.
@export var body_path: NodePath = NodePath("..")
@export var collision_path: NodePath = NodePath("../Collision")
@export var mesh_path: NodePath = NodePath("../Mesh")
@export var interaction_path: NodePath = NodePath("../InteractionComponent")
@export var bottom_offset: float = 0.25
var is_held: bool = false
@onready var body: RigidBody3D = get_node(body_path)
@onready var collision: CollisionShape3D = get_node(collision_path)
@onready var visual: MeshInstance3D = get_node(mesh_path)
@onready var interaction: InteractableComponent = get_node(interaction_path)

func _ready() -> void:
	interaction.used.connect(_on_used)

func _on_used(actor: Node) -> void:
	var handler := actor.get_node_or_null("ObjectHandling")
	if handler != null and handler.has_method("try_pickup"):
		handler.try_pickup(self)
