extends Node3D
## Builds concentric mist rings around the world perimeter while keeping the interior clear.

@export var fog_shader: Shader
@export var day_color := Color(0.05, 0.07, 0.13, 1.0)
@export var night_color := Color(0.05, 0.07, 0.13, 1.0)
@export var wall_height := 14.0

const RING_RADII := [41.0, 43.0, 45.0, 47.0]
const RING_ALPHAS := [0.22, 0.42, 0.65, 0.85]
const OUTER_SOLID_RADIUS := 49.5

var _mist_materials: Array[ShaderMaterial] = []
var _solid_material: StandardMaterial3D

func _ready() -> void:
	for i in RING_RADII.size():
		var mat := ShaderMaterial.new()
		mat.shader = fog_shader
		mat.set_shader_parameter("fog_color", day_color)
		mat.set_shader_parameter("base_alpha", RING_ALPHAS[i])
		_mist_materials.append(mat)
		_add_square_ring(RING_RADII[i], mat)

	_solid_material = StandardMaterial3D.new()
	_solid_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_solid_material.cull_mode = BaseMaterial3D.CULL_DISABLED
	_solid_material.albedo_color = day_color
	_add_square_ring(OUTER_SOLID_RADIUS, _solid_material)

	EventsBus.phase_changed.connect(_on_phase_changed)

func _add_square_ring(half_extent: float, mat: Material) -> void:
	var mesh := CylinderMesh.new()
	mesh.top_radius = half_extent * sqrt(2.0)
	mesh.bottom_radius = half_extent * sqrt(2.0)
	mesh.height = wall_height
	mesh.radial_segments = 4
	mesh.rings = 1
	mesh.cap_top = false
	mesh.cap_bottom = false

	var instance := MeshInstance3D.new()
	instance.mesh = mesh
	instance.material_override = mat
	instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	instance.position.y = wall_height * 0.5 - 0.5
	instance.rotation.y = PI * 0.25
	add_child(instance)

func _on_phase_changed(is_night: bool) -> void:
	var target := night_color if is_night else day_color
	var tween := create_tween().set_parallel(true)
	for mat in _mist_materials:
		tween.tween_method(
			func(c: Color) -> void: mat.set_shader_parameter("fog_color", c),
			mat.get_shader_parameter("fog_color"),
			target,
			1.5
		)
	tween.tween_property(_solid_material, "albedo_color", target, 1.5)
