class_name CardCatalog
extends Resource
@export var schema_version: int = 1
@export var sets: Array[CardSetDefinition] = []
@export var rarities: Array[RarityDefinition] = []
@export var variants: Array[VariantDefinition] = []
@export var cards: Array[CardDefinition] = []
