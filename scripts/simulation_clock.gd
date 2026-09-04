class_name SimulationClock
extends Node

@export var time_scale: float = 1.0

var simulation_time: float = 0.0


func _process(delta: float) -> void:
	_handle_time_controls()

	simulation_time += delta * time_scale


func _handle_time_controls() -> void:
	if Input.is_key_pressed(KEY_0):
		time_scale = 0.0

	if Input.is_key_pressed(KEY_1):
		time_scale = 1.0

	if Input.is_key_pressed(KEY_2):
		time_scale = 10.0

	if Input.is_key_pressed(KEY_3):
		time_scale = 50.0


func get_scaled_delta(delta: float) -> float:
	return delta * time_scale
