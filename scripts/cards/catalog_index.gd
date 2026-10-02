class_name CatalogIndex
extends RefCounted
## Built off to the side so invalid content cannot partially replace the live catalog.
var cards: Dictionary = {}
var sets: Dictionary = {}
var rarities: Dictionary = {}
var variants: Dictionary = {}
var cards_by_set: Dictionary = {}
var cards_by_rarity: Dictionary = {}
var cards_by_variant: Dictionary = {}
var errors: PackedStringArray = []

func build(catalog: CardCatalog) -> bool:
	cards.clear()
	sets.clear()
	rarities.clear()
	variants.clear()
	cards_by_set.clear()
	cards_by_rarity.clear()
	cards_by_variant.clear()
	errors.clear()
	if catalog == null or catalog.schema_version != 1:
		errors.append("Missing catalog or unsupported schema version")
		return false
	_index(catalog.sets, sets, &"set_id", "set")
	_index(catalog.rarities, rarities, &"rarity_id", "rarity")
	_index(catalog.variants, variants, &"variant_id", "variant")
	_index(catalog.cards, cards, &"card_id", "card")
	var collector_keys: Dictionary = {}
	for card: CardDefinition in catalog.cards:
		if card == null:
			continue
		if card.display_name.strip_edges().is_empty() or card.collector_number.strip_edges().is_empty():
			errors.append("Card %s requires a name and collector number" % card.card_id)
		if not sets.has(card.set_id):
			errors.append("Card %s references unknown set %s" % [card.card_id, card.set_id])
		if not rarities.has(card.rarity_id):
			errors.append("Card %s references unknown rarity %s" % [card.card_id, card.rarity_id])
		if card.market_value_minor < 0:
			errors.append("Negative market value: %s" % card.card_id)
		if card.variant_ids.is_empty():
			errors.append("Card %s must support at least one variant" % card.card_id)
		var seen: Dictionary = {}
		for variant_id: StringName in card.variant_ids:
			if not variants.has(variant_id) or seen.has(variant_id):
				errors.append("Unknown or repeated variant %s on %s" % [variant_id, card.card_id])
			seen[variant_id] = true
			_append(cards_by_variant, variant_id, card)
		var collector_key := "%s/%s" % [card.set_id, card.collector_number]
		if collector_keys.has(collector_key):
			errors.append("Duplicate collector number: %s" % collector_key)
		collector_keys[collector_key] = true
		_append(cards_by_set, card.set_id, card)
		_append(cards_by_rarity, card.rarity_id, card)
	for definition: CardSetDefinition in catalog.sets:
		if definition != null and definition.expected_card_count < 0:
			errors.append("Negative set card count: %s" % definition.set_id)
	return errors.is_empty()

func _index(entries: Array, destination: Dictionary, id_property: StringName, label: String) -> void:
	for entry: Resource in entries:
		if entry == null:
			errors.append("Null %s definition" % label)
			continue
		var id: StringName = entry.get(id_property)
		if String(id).strip_edges().is_empty() or destination.has(id):
			errors.append("Empty or duplicate %s ID: %s" % [label, id])
		else:
			destination[id] = entry

func _append(index: Dictionary, key: StringName, card: CardDefinition) -> void:
	if not index.has(key):
		index[key] = []
	index[key].append(card)

func query(index: Dictionary, key: StringName) -> Array[CardDefinition]:
	var result: Array[CardDefinition] = []
	result.assign(index.get(key, []))
	return result
