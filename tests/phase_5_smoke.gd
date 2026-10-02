extends Node
var failures: int = 0

func _ready() -> void:
	var source := load(CardDatabase.DEFAULT_CATALOG) as CardCatalog
	_check(CardDatabase.is_loaded and CardDatabase.get_card_count() == 4, "Default catalog loads")
	_check(CardDatabase.get_set(&"meadow_demo").expected_card_count == 4, "Set lookup")
	_check(CardDatabase.get_card(&"missing") == null, "Missing card returns null")
	_check(CardDatabase.get_cards_in_set(&"missing").is_empty(), "Unknown set returns empty array")
	_check(CardDatabase.get_cards_by_rarity(&"common").size() == 2, "Rarity index")
	_check(CardDatabase.get_cards_by_variant(&"normal").size() == 3, "Variant index")
	_check(not CardDatabase.get_card(&"meadow_aurorawing").variant_ids.has(&"normal"), "Variants differ per card")
	_check(CardDatabase.search_cards("  SPROUT ").size() == 1, "Normalized name search")
	var returned := CardDatabase.get_cards_in_set(&"meadow_demo")
	returned.clear()
	_check(CardDatabase.get_cards_in_set(&"meadow_demo").size() == 4, "Query arrays cannot mutate index")

	var invalid := source.duplicate(true) as CardCatalog
	invalid.cards.append(invalid.cards[0])
	_check(not CardDatabase.replace_catalog(invalid), "Duplicate ID rejected")
	_check(CardDatabase.get_card_count() == 4 and not CardDatabase.last_errors.is_empty(), "Failed replacement retains live catalog")
	for field: StringName in [&"set_id", &"rarity_id", &"market_value_minor", &"collector_number"]:
		invalid = source.duplicate(true) as CardCatalog
		if field == &"market_value_minor":
			invalid.cards[0].set(field, -1)
		elif field == &"collector_number":
			invalid.cards[0].set(field, invalid.cards[1].collector_number)
		else:
			invalid.cards[0].set(field, &"missing")
		_check(not CatalogIndex.new().build(invalid), "Invalid field rejected: %s" % field)
	invalid = source.duplicate(true) as CardCatalog
	invalid.cards[0].variant_ids = [&"missing"]
	_check(not CatalogIndex.new().build(invalid), "Unknown variant rejected")
	invalid.cards[0].variant_ids = [&"normal", &"normal"]
	_check(not CatalogIndex.new().build(invalid), "Repeated variant rejected")
	invalid.cards[0].variant_ids.clear()
	_check(not CatalogIndex.new().build(invalid), "Empty variant list rejected")
	invalid = source.duplicate(true) as CardCatalog
	invalid.cards.append(null)
	_check(not CatalogIndex.new().build(invalid), "Null definition rejected")
	invalid.schema_version = 2
	_check(not CatalogIndex.new().build(invalid), "Unknown schema rejected")

	var large := source.duplicate(true) as CardCatalog
	large.cards.clear()
	for number: int in range(3000):
		var card := source.cards[0].duplicate(true) as CardDefinition
		card.card_id = StringName("generated_%d" % number)
		card.collector_number = str(number)
		large.cards.append(card)
	var index := CatalogIndex.new()
	_check(index.build(large) and index.cards.size() == 3000, "3000 generated definitions index successfully")
	_check(index.query(index.cards_by_set, &"meadow_demo").size() == 3000, "Large set index returns all cards")
	var path := "user://phase5_catalog_test.tres"
	_check(ResourceSaver.save(source, path) == OK, "Resource serializes")
	var roundtrip := ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE) as CardCatalog
	_check(CatalogIndex.new().build(roundtrip) and roundtrip.cards.size() == 4, "Resource roundtrip")
	DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
	_check(CardDatabase.replace_catalog(source) and CardDatabase.last_errors.is_empty(), "Valid replacement clears errors")
	print("PHASE 5 SMOKE: %d failures" % failures)
	get_tree().quit(failures)

func _check(condition: bool, label: String) -> void:
	if not condition:
		failures += 1
		push_error(label)
	else:
		print("PASS: " + label)
