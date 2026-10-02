class_name CardDefinition
extends Resource
## Immutable catalog content. Ownership and quantities belong to future collection data.
@export var card_id: StringName
@export var display_name: String
@export var creature_name: String
@export var set_id: StringName
@export var collector_number: String
@export var rarity_id: StringName
@export var variant_ids: Array[StringName] = []
@export var element_id: StringName
@export var market_value_minor: int = 0
@export var art_texture: Texture2D
@export var foil_mask: Texture2D
@export var collection_category: StringName = &"creature"
