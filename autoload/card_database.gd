extends Node
signal catalog_loaded(card_count: int)
signal catalog_rejected(errors: PackedStringArray)
const DEFAULT_CATALOG: String = "res://data/cards/sample_catalog.tres"
var _index: CatalogIndex = CatalogIndex.new()
var is_loaded: bool = false
var last_errors: PackedStringArray = []

func _ready() -> void:
	DebugManager.register_snapshot_provider(&"card_catalog", _get_debug_snapshot)
	if not load_catalog(DEFAULT_CATALOG):
		push_error("Card catalog failed validation: %s" % last_errors)

func load_catalog(path: String) -> bool:
	var catalog := ResourceLoader.load(path) as CardCatalog
	return replace_catalog(catalog)

func replace_catalog(catalog: CardCatalog) -> bool:
	var candidate := CatalogIndex.new()
	if not candidate.build(catalog):
		last_errors = candidate.errors.duplicate()
		catalog_rejected.emit(last_errors.duplicate())
		return false
	_index = candidate
	is_loaded = true
	last_errors.clear()
	catalog_loaded.emit(_index.cards.size())
	return true

func get_card(id: StringName) -> CardDefinition:
	return _index.cards.get(id) as CardDefinition

func get_set(id: StringName) -> CardSetDefinition:
	return _index.sets.get(id) as CardSetDefinition

func get_rarity(id: StringName) -> RarityDefinition:
	return _index.rarities.get(id) as RarityDefinition

func get_variant(id: StringName) -> VariantDefinition:
	return _index.variants.get(id) as VariantDefinition

func get_card_count() -> int:
	return _index.cards.size()

func get_set_ids() -> Array[StringName]:
	var result: Array[StringName] = []
	result.assign(_index.sets.keys())
	return result

func get_cards_in_set(id: StringName) -> Array[CardDefinition]:
	return _index.query(_index.cards_by_set, id)

func get_cards_by_rarity(id: StringName) -> Array[CardDefinition]:
	return _index.query(_index.cards_by_rarity, id)

func get_cards_by_variant(id: StringName) -> Array[CardDefinition]:
	return _index.query(_index.cards_by_variant, id)

func search_cards(text: String) -> Array[CardDefinition]:
	var result: Array[CardDefinition] = []
	var needle := text.strip_edges().to_lower()
	for card: CardDefinition in _index.cards.values():
		if needle.is_empty() or card.display_name.to_lower().contains(needle) or card.creature_name.to_lower().contains(needle):
			result.append(card)
	return result

func _get_debug_snapshot() -> Dictionary:
	return {"catalog_cards": get_card_count(), "catalog_sets": _index.sets.size()}

