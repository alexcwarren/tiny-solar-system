class_name CelestialBody
extends Node3D

@export_category("Appearance")

## Radius of the celestial body in Godot units.
@export var body_radius: float = 10.0:
	set(value):
		body_radius = max(value, 0.01)
		_update_body()

## Base visible color of the body.
@export var body_color: Color = Color.WHITE:
	set(value):
		body_color = value
		_update_body()

## Optional texture for the surface.
@export var surface_texture: Texture2D:
	set(value):
		surface_texture = value
		_update_body()

@export_category("Rotation")

## Whether this body rotates around its own axis.
@export var rotates: bool = true

## How many seconds it takes to complete one full rotation.
## Smaller values = faster rotation.
@export var rotation_period: float = 20.0

## Tilt of this body's rotation axis, in degrees.
@export_range(-90.0, 90.0, 1.0)
var axial_tilt: float = 0.0:
	set(value):
		axial_tilt = value
		_update_axial_tilt()

@export_category("Orbit")

## The body this celestial body orbits.
## Examples:
## - Planet -> Sun
## - Moon -> Planet
## Leave empty for a body that does not orbit anything.
@export var orbit_parent: Node3D

## Distance from the orbit parent, in Godot units.
@export var orbital_radius: float = 100.0

## Starting position around the orbit, in degrees.
@export_range(0.0, 360.0, 1.0)
var initial_orbital_angle: float = 0.0

## How many seconds it takes to complete one orbit.
@export var orbital_period: float = 60.0

const CLOCKWISE: String = "Clockwise"
const COUNTER_CLOCKWISE: String = "Counter-Clockwise"
@export_enum(CLOCKWISE, COUNTER_CLOCKWISE)
var orbital_direction: String = COUNTER_CLOCKWISE

## Tilts the orbital plane in degrees.
@export_range(-90.0, 90.0, 1.0)
var orbital_inclination: float = 0.0

@export_category("Simulation")

@export var simulation_clock: SimulationClock

@export_category("Emission")

@export var emission_enabled: bool = false

@export var emission_color: Color = Color.WHITE

@export var emission_energy: float = 1.0

@onready var axial_tilt_node: Node3D = $AxialTilt

@onready var mesh_instance: MeshInstance3D = $AxialTilt/Mesh

var current_orbital_angle: float


func _ready() -> void:
	DebugLog.log_info(self, "ready")
	current_orbital_angle = initial_orbital_angle
	_update_body()
	_update_axial_tilt()


func _update_body() -> void:
	if not is_node_ready():
		DebugLog.log_warning(self, "Node not ready")
		return

	_update_size()
	_update_material()


func _update_size() -> void:
	# The default SphereMesh has a radius of 0.5 units.
	# Scaling it by body_radius * 2 makes the visible radius
	# correspond to body_radius in Godot units.
	var diameter := body_radius * 2.0

	mesh_instance.scale = Vector3.ONE * diameter


func _update_material() -> void:
	var material := StandardMaterial3D.new()

	material.albedo_color = body_color
	material.albedo_texture = surface_texture

	material.emission_enabled = emission_enabled

	if emission_enabled:
		material.emission = emission_color
		material.emission_energy_multiplier = emission_energy

	mesh_instance.material_override = material


func _update_rotation(delta: float) -> void:
	if not rotates:
		return

	if rotation_period <= 0.0:
		return

	var angular_speed := TAU / rotation_period
	mesh_instance.rotate_y(angular_speed * delta)


func _update_axial_tilt() -> void:
	if not is_node_ready():
		return

	axial_tilt_node.rotation_degrees.z = axial_tilt


func _update_orbit(delta: float) -> void:
	if orbit_parent == null:
		return

	if orbital_period <= 0.0:
		return

	var angular_speed := TAU / orbital_period

	current_orbital_angle += rad_to_deg(angular_speed * delta)
	current_orbital_angle = fmod(current_orbital_angle, 360.0)

	var angle_radians := deg_to_rad(current_orbital_angle)

	var direction_sign: int = 1 if orbital_direction == CLOCKWISE else -1
	var offset := Vector3(
		cos(angle_radians) * orbital_radius,
		0.0,
		direction_sign * sin(angle_radians) * orbital_radius
	)
	offset = offset.rotated(
		Vector3.FORWARD,
		deg_to_rad(orbital_inclination)
	)
	global_position = orbit_parent.global_position + offset


func _process(delta: float) -> void:
	var simulation_delta := delta

	if simulation_clock != null:
		simulation_delta = simulation_clock.get_scaled_delta(delta)

	_update_rotation(simulation_delta)
	_update_orbit(simulation_delta)
