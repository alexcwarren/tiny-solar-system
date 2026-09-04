extends Node

@export var enabled: bool = true

@export var light_on: bool = true

@export var starting_position: Vector3 = 100 * Vector3.ONE


const DEBUGGER_CAMERA_SCENE := preload(
	"./debugger_camera.tscn"
)


func _ready() -> void:
	if not enabled:
		return

	# The parent is the scene we're trying to preview.
	var previewed_scene := get_parent()

	# Only create a camera when that scene itself was launched with F6.
	#
	# If CelestialBody is instantiated inside Main:
	#     current_scene == Main
	#     previewed_scene == CelestialBody
	#     therefore no debugger camera.
	if get_tree().current_scene != previewed_scene:
		return

	var debugger_camera := DEBUGGER_CAMERA_SCENE.instantiate()
	debugger_camera.enable_debug_light = light_on
	debugger_camera.starting_position = starting_position
	previewed_scene.add_child.call_deferred(debugger_camera)
