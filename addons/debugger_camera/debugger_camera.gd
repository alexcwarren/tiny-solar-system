extends Node3D

@export_category("Movement")

@export var move_speed: float = 25.0
@export var look_sensitivity: float = 0.003

@export_category("Debug Lighting")

@export var enable_debug_light: bool = true

@export_category("Starting View")

@export var starting_position: Vector3 = Vector3(0.0, 20.0, 100.0)

@onready var camera: Camera3D = $Camera3D
@onready var debug_light: DirectionalLight3D = $DebugLight

var _looking := false


func _ready() -> void:
	global_position = starting_position

	camera.current = true
	debug_light.visible = enable_debug_light


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			_looking = event.pressed

	if event is InputEventMouseMotion and _looking:
		rotate_y(-event.relative.x * look_sensitivity)
		camera.rotate_x(-event.relative.y * look_sensitivity)

		# Prevent flipping upside down.
		camera.rotation.x = clamp(
			camera.rotation.x,
			deg_to_rad(-89.0),
			deg_to_rad(89.0)
		)


func _process(delta: float) -> void:
	var input_direction := Vector3.ZERO

	if Input.is_key_pressed(KEY_W):
		if Input.is_key_pressed(KEY_SHIFT):
			input_direction.y += 1.0
		else:
			input_direction.z -= 1.0

	if Input.is_key_pressed(KEY_S):
		if Input.is_key_pressed(KEY_SHIFT):
			input_direction.y -= 1.0
		else:
			input_direction.z += 1.0

	if Input.is_key_pressed(KEY_A):
		input_direction.x -= 1.0

	if Input.is_key_pressed(KEY_D):
		input_direction.x += 1.0

	if Input.is_key_pressed(KEY_Q):
		input_direction.y -= 1.0

	if Input.is_key_pressed(KEY_E):
		input_direction.y += 1.0

	if input_direction == Vector3.ZERO:
		return

	input_direction = input_direction.normalized()

	# Convert local movement into world-space movement based on
	# the direction the debugger camera is facing.
	var movement := global_transform.basis * input_direction

	global_position += movement * move_speed * delta
