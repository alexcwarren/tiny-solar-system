class_name DebugLog
extends RefCounted

enum LogLevel {
	DEBUG,
	INFO,
	WARNING,
	ERROR,
	CRITICAL,
}

const _LEVEL_STR: Dictionary[LogLevel, String] = {
	LogLevel.DEBUG: "DEBUG",
	LogLevel.INFO: "INFO",
	LogLevel.WARNING: "WARNING",
	LogLevel.ERROR: "ERROR",
	LogLevel.CRITICAL: "CRITICAL",
}

static var _enabled: bool = true
static var _level: LogLevel = LogLevel.ERROR


static func is_enabled() -> bool:
	return _enabled


static func set_enabled(enable: bool) -> void:
	_enabled = enable


static func set_level(level: LogLevel) -> void:
	_level = level


static func log_info(source: Object, message: String) -> void:
	_log(source, message, Time.get_datetime_string_from_system(), LogLevel.INFO)


static func log_warning(source: Object, message: String) -> void:
	_log(source, message, Time.get_datetime_string_from_system(), LogLevel.WARNING)


static func log_error(source: Object, message: String) -> void:
	_log(source, message, Time.get_datetime_string_from_system(), LogLevel.ERROR)


static func log_critical(source: Object, message: String) -> void:
	_log(source, message, Time.get_datetime_string_from_system(), LogLevel.CRITICAL)


static func _log(
	source: Object, message: String, timestamp: String, level: LogLevel
) -> void:
	if not is_enabled() or level < _level:
		return

	var script_name: String = "UnknownScript"
	var node_name: String = "UnknownNode"

	if source != null:
		node_name = str(source.name) if source is Node else str(source)

		var script := source.get_script() as Script
		if script != null:
			var script_path: String = script.resource_path
			if script_path != "":
				script_name = script_path.get_file().get_basename()

	print(
		"%s\t%s\t[%s:%s]\t%s" % [
			timestamp,
			_LEVEL_STR.get(level, "UNKNOWN_LEVEL"),
			script_name,
			node_name,
			message,
		]
	)
