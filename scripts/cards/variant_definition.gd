class_name VariantDefinition
extends Resource
## An edition's display metadata; no assumption that every card supports every variant.
@export var variant_id: StringName
@export var display_name: String
@export var sort_order: int = 0
@export var foil_style_id: StringName = &"none"
