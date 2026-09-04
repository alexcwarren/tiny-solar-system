extends Node3D

@export var current_scene: PackedScene


func _ready() -> void:
	if current_scene == null:
		return

	get_tree().change_scene_to_packed.call_deferred(current_scene)
