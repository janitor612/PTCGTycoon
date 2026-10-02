extends Node
## Explicit opt-in persistence. Never loads or overwrites a save during startup.
signal save_completed(path: String)
signal load_completed(data: Dictionary)
signal operation_failed(message: String)
const SAVE_VERSION: int = 1
const DEFAULT_PATH: String = "user://save_v1.json"

func create_envelope(payload: Dictionary) -> Dictionary:
	return {"version": SAVE_VERSION, "saved_at_unix": Time.get_unix_time_from_system(), "payload": payload.duplicate(true)}

func save_payload(payload: Dictionary, path: String = DEFAULT_PATH) -> Error:
	# Temporary write + backup protects an existing save if replacement fails.
	var temporary_path := path + ".tmp"
	var file := FileAccess.open(temporary_path, FileAccess.WRITE)
	if file == null:
		return _fail("Cannot open temporary save", FileAccess.get_open_error())
	file.store_string(JSON.stringify(create_envelope(payload), "\t"))
	file.flush()
	var write_error := file.get_error()
	file.close()
	if write_error != OK:
		return _fail("Cannot write save", write_error)
	var absolute_path := ProjectSettings.globalize_path(path)
	var backup_path := absolute_path + ".bak"
	if FileAccess.file_exists(path):
		if FileAccess.file_exists(backup_path):
			var cleanup_error := DirAccess.remove_absolute(backup_path)
			if cleanup_error != OK:
				return _fail("Cannot rotate save backup", cleanup_error)
		var backup_error := DirAccess.rename_absolute(absolute_path, backup_path)
		if backup_error != OK:
			return _fail("Cannot back up save", backup_error)
	var replace_error := DirAccess.rename_absolute(ProjectSettings.globalize_path(temporary_path), absolute_path)
	if replace_error != OK:
		if FileAccess.file_exists(backup_path):
			DirAccess.rename_absolute(backup_path, absolute_path)
		return _fail("Cannot replace save", replace_error)
	save_completed.emit(path)
	return OK

func load_payload(path: String = DEFAULT_PATH) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		_fail("Cannot open save", FileAccess.get_open_error())
		return {}
	var json := JSON.new()
	var parse_error := json.parse(file.get_as_text())
	file.close()
	if parse_error != OK or not json.data is Dictionary:
		_fail("Invalid save JSON", ERR_PARSE_ERROR)
		return {}
	var envelope: Dictionary = json.data
	# Future migration functions belong here; unknown versions must be preserved.
	if envelope.get("version") != SAVE_VERSION or not envelope.get("payload") is Dictionary:
		_fail("Unsupported save version or payload", ERR_INVALID_DATA)
		return {}
	var payload: Dictionary = envelope["payload"].duplicate(true)
	load_completed.emit(payload)
	return payload

func _fail(message: String, error: Error) -> Error:
	operation_failed.emit(message)
	return error
