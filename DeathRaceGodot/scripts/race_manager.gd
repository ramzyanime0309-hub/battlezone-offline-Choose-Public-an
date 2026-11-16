extends Node3D

const CAR_SCRIPT = preload("res://scripts/car_controller.gd")
const TRACK_ROUTE: Array[Vector3] = [
	Vector3(0, 0, -27), Vector3(39, 0, -27), Vector3(39, 0, 27),
	Vector3(-39, 0, 27), Vector3(-39, 0, -27), Vector3(0, 0, -27)
]

var player: RigidBody3D
var follow_camera: Camera3D
var speed_label: Label
var lap_label: Label
var status_label: Label
var nitro_bar: ProgressBar
var countdown: float = 3.0
var race_started: bool = false
var finished: bool = false
var next_checkpoint: int = 0
var lap: int = 1
var elapsed: float = 0.0

func _ready() -> void:
	_build_environment()
	_build_track()
	_build_cars()
	_build_camera()
	_build_hud()

func _process(delta: float) -> void:
	if player == null:
		return
	_update_camera(delta)
	if not race_started and not finished:
		countdown -= delta
		status_label.text = "GET READY  %d" % maxi(1, ceili(countdown)) if countdown > 0.0 else "GO!"
		if countdown <= 0.0:
			race_started = true
			player.race_enabled = true
			for rival in get_tree().get_nodes_in_group("rivals"):
				rival.race_enabled = true
			status_label.text = "RACE ON"
	if race_started and not finished:
		elapsed += delta
		_check_checkpoint()
		speed_label.text = "%03d  KM/H" % roundi(player.linear_velocity.length() * 3.6)
		lap_label.text = "LAP  %d / 3" % mini(lap, 3)
		nitro_bar.value = player.nitro
	if finished:
		speed_label.text = "%03d  KM/H" % roundi(player.linear_velocity.length() * 3.6)

func _build_environment() -> void:
	var world := WorldEnvironment.new()
	var environment := Environment.new()
	environment.background_mode = Environment.BG_SKY
	environment.sky = Sky.new()
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color(0.72, 0.78, 0.86)
	environment.ambient_light_energy = 0.65
	world.environment = environment
	add_child(world)

	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-52, -28, 0)
	sun.light_energy = 1.25
	sun.shadow_enabled = true
	add_child(sun)

func _build_track() -> void:
	_add_static_box("Grass field", Vector3(0, -0.7, 0), Vector3(120, 1, 90), Color(0.12, 0.31, 0.16))
	_add_visual_box("North road", Vector3(0, -0.12, -27), Vector3(82, 0.18, 18), Color(0.12, 0.13, 0.15))
	_add_visual_box("South road", Vector3(0, -0.12, 27), Vector3(82, 0.18, 18), Color(0.12, 0.13, 0.15))
	_add_visual_box("East road", Vector3(39, -0.12, 0), Vector3(18, 0.18, 36), Color(0.12, 0.13, 0.15))
	_add_visual_box("West road", Vector3(-39, -0.12, 0), Vector3(18, 0.18, 36), Color(0.12, 0.13, 0.15))
	_add_visual_box("Inner island", Vector3(0, -0.04, 0), Vector3(42, 0.12, 36), Color(0.15, 0.36, 0.18))

	# Outer safety walls and inner island barriers.
	_add_static_box("Outer north barrier", Vector3(0, 1.0, -45), Vector3(100, 2, 1.2), Color(0.85, 0.22, 0.12))
	_add_static_box("Outer south barrier", Vector3(0, 1.0, 45), Vector3(100, 2, 1.2), Color(0.85, 0.22, 0.12))
	_add_static_box("Outer east barrier", Vector3(50, 1.0, 0), Vector3(1.2, 2, 90), Color(0.85, 0.22, 0.12))
	_add_static_box("Outer west barrier", Vector3(-50, 1.0, 0), Vector3(1.2, 2, 90), Color(0.85, 0.22, 0.12))
	_add_static_box("Inner north barrier", Vector3(0, 0.9, -9), Vector3(44, 1.8, 1.0), Color(0.9, 0.82, 0.16))
	_add_static_box("Inner south barrier", Vector3(0, 0.9, 9), Vector3(44, 1.8, 1.0), Color(0.9, 0.82, 0.16))
	_add_static_box("Inner east barrier", Vector3(22, 0.9, 0), Vector3(1.0, 1.8, 18), Color(0.9, 0.82, 0.16))
	_add_static_box("Inner west barrier", Vector3(-22, 0.9, 0), Vector3(1.0, 1.8, 18), Color(0.9, 0.82, 0.16))

func _add_visual_box(label: String, pos: Vector3, size: Vector3, color: Color) -> void:
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = label
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh_instance.mesh = mesh
	mesh_instance.position = pos
	mesh_instance.material_override = _material(color)
	add_child(mesh_instance)

func _add_static_box(label: String, pos: Vector3, size: Vector3, color: Color) -> void:
	var body := StaticBody3D.new()
	body.name = label
	body.position = pos
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = size
	collision.shape = shape
	body.add_child(collision)
	var visual := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = size
	visual.mesh = mesh
	visual.material_override = _material(color)
	body.add_child(visual)
	add_child(body)

func _build_cars() -> void:
	player = _make_car("Player", Vector3(0, 0.65, 31), Color(0.08, 0.48, 0.95), false)
	player.race_enabled = false
	var rival_specs := [
		["Rival Red", Vector3(-4.0, 0.65, 34.5), Color(0.88, 0.12, 0.08), 0.78],
		["Rival Gold", Vector3(4.0, 0.65, 38.0), Color(0.95, 0.62, 0.08), 0.74],
		["Rival White", Vector3(-8.0, 0.65, 38.0), Color(0.82, 0.86, 0.9), 0.76]
	]
	for spec in rival_specs:
		var rival := _make_car(spec[0], spec[1], spec[2], true)
		rival.ai_speed = spec[3]
		rival.race_enabled = false
		rival.add_to_group("rivals")

func _make_car(label: String, pos: Vector3, color: Color, ai: bool) -> RigidBody3D:
	var car := RigidBody3D.new()
	car.name = label
	car.position = pos
	car.mass = 1150.0
	car.gravity_scale = 0.0
	car.linear_damp = 0.16
	car.angular_damp = 4.0
	car.continuous_cd = true
	car.set_script(CAR_SCRIPT)
	car.is_ai = ai
	car.waypoints = TRACK_ROUTE.duplicate()

	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(1.9, 0.85, 3.8)
	collision.shape = shape
	car.add_child(collision)

	var body_mesh := MeshInstance3D.new()
	var body_box := BoxMesh.new()
	body_box.size = Vector3(1.9, 0.65, 3.8)
	body_mesh.mesh = body_box
	body_mesh.position.y = 0.05
	body_mesh.material_override = _material(color)
	car.add_child(body_mesh)

	var cabin := MeshInstance3D.new()
	var cabin_box := BoxMesh.new()
	cabin_box.size = Vector3(1.45, 0.58, 1.75)
	cabin.mesh = cabin_box
	cabin.position = Vector3(0, 0.58, 0.15)
	cabin.material_override = _material(Color(0.055, 0.075, 0.095))
	car.add_child(cabin)

	for x in [-1.0, 1.0]:
		for z in [-1.25, 1.25]:
			var wheel := MeshInstance3D.new()
			var wheel_mesh := CylinderMesh.new()
			wheel_mesh.top_radius = 0.38
			wheel_mesh.bottom_radius = 0.38
			wheel_mesh.height = 0.24
			wheel.mesh = wheel_mesh
			wheel.rotation_degrees.z = 90
			wheel.position = Vector3(x, -0.22, z)
			wheel.material_override = _material(Color(0.025, 0.025, 0.03))
			car.add_child(wheel)
	add_child(car)
	return car

func _build_camera() -> void:
	follow_camera = Camera3D.new()
	follow_camera.current = true
	follow_camera.fov = 72.0
	add_child(follow_camera)
	follow_camera.global_position = player.global_position + Vector3(0, 13, 19)
	follow_camera.look_at(player.global_position + Vector3(0, 0, -7), Vector3.UP)

func _update_camera(delta: float) -> void:
	var desired := player.global_position + player.global_transform.basis * Vector3(0, 10, 18)
	follow_camera.global_position = follow_camera.global_position.lerp(desired, clampf(delta * 4.0, 0.0, 1.0))
	follow_camera.look_at(player.global_position + Vector3(0, 0.8, -5), Vector3.UP)

func _build_hud() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(root)

	speed_label = _make_label(root, "000 KM/H", Rect2(28, 22, 260, 62), 34)
	lap_label = _make_label(root, "LAP 1 / 3", Rect2(540, 22, 220, 54), 26)
	status_label = _make_label(root, "GET READY  3", Rect2(430, 86, 420, 60), 30)
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	nitro_bar = ProgressBar.new()
	nitro_bar.position = Vector2(470, 154)
	nitro_bar.size = Vector2(340, 22)
	nitro_bar.max_value = 100
	nitro_bar.value = 100
	nitro_bar.show_percentage = false
	root.add_child(nitro_bar)

	_add_touch_button(root, "LEFT", Rect2(24, 560, 118, 118), "left")
	_add_touch_button(root, "RIGHT", Rect2(152, 560, 118, 118), "right")
	_add_touch_button(root, "BRAKE", Rect2(875, 575, 112, 100), "brake")
	_add_touch_button(root, "DRIFT", Rect2(995, 575, 112, 100), "drift")
	_add_touch_button(root, "GAS", Rect2(1110, 530, 140, 145), "accelerate")
	_add_touch_button(root, "NITRO", Rect2(1080, 390, 150, 105), "nitro")

func _make_label(parent: Control, value: String, rect: Rect2, font_size: int) -> Label:
	var label := Label.new()
	label.text = value
	label.position = rect.position
	label.size = rect.size
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color.WHITE)
	label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.85))
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 2)
	parent.add_child(label)
	return label

func _add_touch_button(parent: Control, caption: String, rect: Rect2, action: String) -> void:
	var button := Button.new()
	button.text = caption
	button.position = rect.position
	button.size = rect.size
	button.add_theme_font_size_override("font_size", 20)
	button.modulate = Color(1, 1, 1, 0.88)
	button.button_down.connect(Callable(player, "set_control").bind(action, true))
	button.button_up.connect(Callable(player, "set_control").bind(action, false))
	parent.add_child(button)

func _check_checkpoint() -> void:
	if player.global_position.distance_to(TRACK_ROUTE[next_checkpoint]) < 10.0:
		next_checkpoint += 1
		if next_checkpoint >= TRACK_ROUTE.size():
			next_checkpoint = 0
			lap += 1
			if lap > 3:
				finished = true
				race_started = false
				player.race_enabled = false
				status_label.text = "FINISH!  TIME %.1f s" % elapsed

func _material(color: Color) -> StandardMaterial3D:
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = 0.82
	return mat
