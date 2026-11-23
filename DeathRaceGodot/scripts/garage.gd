extends Control

const CAR_CATALOG = preload("res://scripts/car_catalog.gd")

var cars: Array[Dictionary] = []
var selected_index: int = 0
var list_buttons: Array[Button] = []
var preview_world: Node3D
var preview_car: Node3D
var name_label: Label
var category_label: Label
var description_label: Label
var stats_label: Label
var status_label: Label
var start_race_button: Button

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	cars = CAR_CATALOG.all_cars()
	_build_ui()
	if cars.is_empty():
		status_label.text = "NO CARS FOUND"
	else:
		_select_car(0)

func _process(delta: float) -> void:
	if is_instance_valid(preview_car):
		preview_car.rotate_y(delta * 0.25)

func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color(0.025, 0.035, 0.055, 1.0)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)

	var title := Label.new()
	title.text = "DEATH RACE"
	title.position = Vector2(32, 22)
	title.size = Vector2(430, 54)
	title.add_theme_font_size_override("font_size", 38)
	title.add_theme_color_override("font_color", Color.WHITE)
	add_child(title)

	var subtitle := Label.new()
	subtitle.text = "HYPERCAR GARAGE  /  OFFLINE SINGLE PLAYER"
	subtitle.position = Vector2(35, 76)
	subtitle.size = Vector2(560, 28)
	subtitle.add_theme_font_size_override("font_size", 15)
	subtitle.add_theme_color_override("font_color", Color(0.55, 0.72, 0.88))
	add_child(subtitle)

	var collection_panel := PanelContainer.new()
	collection_panel.position = Vector2(28, 120)
	collection_panel.size = Vector2(260, 510)
	add_child(collection_panel)

	var collection_box := VBoxContainer.new()
	collection_box.add_theme_constant_override("separation", 8)
	collection_panel.add_child(collection_box)

	var collection_title := Label.new()
	collection_title.text = "CAR COLLECTION"
	collection_title.add_theme_font_size_override("font_size", 18)
	collection_box.add_child(collection_title)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	collection_box.add_child(scroll)

	var car_list := VBoxContainer.new()
	car_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(car_list)

	for index in range(cars.size()):
		var definition: Dictionary = cars[index]
		var button := Button.new()
		button.text = "%s\n%s" % [String(definition.get("manufacturer", "")), String(definition.get("model", ""))]
		button.custom_minimum_size = Vector2(0, 58)
		button.toggle_mode = true
		button.add_theme_font_size_override("font_size", 14)
		button.pressed.connect(_select_car.bind(index))
		car_list.add_child(button)
		list_buttons.append(button)

	var preview_panel := PanelContainer.new()
	preview_panel.position = Vector2(310, 120)
	preview_panel.size = Vector2(600, 510)
	add_child(preview_panel)

	var preview_container := SubViewportContainer.new()
	preview_container.stretch = true
	preview_container.custom_minimum_size = Vector2(580, 490)
	var headless_validation := DisplayServer.get_name() == "headless"
	preview_container.visible = not headless_validation
	preview_panel.add_child(preview_container)

	var viewport := SubViewport.new()
	viewport.size = Vector2i(580, 490)
	viewport.render_target_update_mode = SubViewport.UPDATE_DISABLED if headless_validation else SubViewport.UPDATE_ALWAYS
	preview_container.add_child(viewport)

	preview_world = Node3D.new()
	viewport.add_child(preview_world)

	var world_environment := WorldEnvironment.new()
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color(0.035, 0.055, 0.085)
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color(0.72, 0.8, 0.92)
	environment.ambient_light_energy = 0.8
	world_environment.environment = environment
	preview_world.add_child(world_environment)

	var light := DirectionalLight3D.new()
	light.rotation_degrees = Vector3(-35, -30, 0)
	light.light_energy = 1.4
	preview_world.add_child(light)

	var camera := Camera3D.new()
	camera.position = Vector3(4.2, 3.0, 7.8)
	preview_world.add_child(camera)
	camera.look_at(Vector3(0, 0.45, 0), Vector3.UP)
	camera.make_current()

	var floor := MeshInstance3D.new()
	var floor_mesh := PlaneMesh.new()
	floor_mesh.size = Vector2(12, 12)
	floor.mesh = floor_mesh
	floor.position.y = -0.04
	var floor_material := StandardMaterial3D.new()
	floor_material.albedo_color = Color(0.075, 0.095, 0.13)
	floor_material.roughness = 0.9
	floor.material_override = floor_material
	preview_world.add_child(floor)

	var information_panel := PanelContainer.new()
	information_panel.position = Vector2(930, 120)
	information_panel.size = Vector2(320, 510)
	add_child(information_panel)

	var information := VBoxContainer.new()
	information.add_theme_constant_override("separation", 12)
	information_panel.add_child(information)

	name_label = Label.new()
	name_label.add_theme_font_size_override("font_size", 25)
	name_label.add_theme_color_override("font_color", Color.WHITE)
	name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	information.add_child(name_label)

	category_label = Label.new()
	category_label.add_theme_font_size_override("font_size", 14)
	category_label.add_theme_color_override("font_color", Color(0.55, 0.72, 0.88))
	information.add_child(category_label)

	description_label = Label.new()
	description_label.custom_minimum_size = Vector2(0, 104)
	description_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	description_label.add_theme_font_size_override("font_size", 15)
	information.add_child(description_label)

	stats_label = Label.new()
	stats_label.add_theme_font_size_override("font_size", 17)
	stats_label.add_theme_color_override("font_color", Color(0.9, 0.93, 0.98))
	information.add_child(stats_label)

	status_label = Label.new()
	status_label.text = "AVAILABLE IN PROTOTYPE"
	status_label.add_theme_font_size_override("font_size", 13)
	status_label.add_theme_color_override("font_color", Color(0.45, 0.85, 0.68))
	information.add_child(status_label)

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	information.add_child(spacer)

	start_race_button = Button.new()
	start_race_button.text = "START RACE"
	start_race_button.custom_minimum_size = Vector2(0, 58)
	start_race_button.add_theme_font_size_override("font_size", 19)
	start_race_button.pressed.connect(_start_race)
	information.add_child(start_race_button)

	var footer := Label.new()
	footer.text = "PROTOTYPE TUNING VALUES  /  ORIGINAL PLACEHOLDER VEHICLE MODELS"
	footer.position = Vector2(32, 665)
	footer.size = Vector2(850, 28)
	footer.add_theme_font_size_override("font_size", 13)
	footer.add_theme_color_override("font_color", Color(0.48, 0.57, 0.68))
	add_child(footer)

func _select_car(index: int) -> void:
	if cars.is_empty():
		return
	selected_index = posmod(index, cars.size())
	var definition: Dictionary = cars[selected_index]
	name_label.text = String(definition.get("display_name", "Unknown Car"))
	category_label.text = String(definition.get("category", "Hypercar"))
	description_label.text = String(definition.get("description", ""))
	stats_label.text = "TOP SPEED   %d KM/H\nACCELERATION   %d / 100\nHANDLING   %d / 100\nNITRO   %d / 100" % [
		int(definition.get("top_speed_kmh", 0)),
		int(definition.get("acceleration_rating", 0)),
		int(definition.get("handling_rating", 0)),
		int(definition.get("nitro_rating", 0))
	]
	for button_index in range(list_buttons.size()):
		list_buttons[button_index].button_pressed = button_index == selected_index
	_build_preview_car(definition)

func _build_preview_car(definition: Dictionary) -> void:
	if is_instance_valid(preview_car):
		preview_car.queue_free()
	preview_car = Node3D.new()
	preview_world.add_child(preview_car)

	var body_material := StandardMaterial3D.new()
	body_material.albedo_color = Color.html(String(definition.get("body_color", "#1f78bd")))
	body_material.metallic = 0.55
	body_material.roughness = 0.28

	var body := MeshInstance3D.new()
	var body_mesh := BoxMesh.new()
	body_mesh.size = Vector3(1.9, 0.5, 3.7)
	body.mesh = body_mesh
	body.position.y = 0.48
	body.material_override = body_material
	preview_car.add_child(body)

	var nose := MeshInstance3D.new()
	var nose_mesh := BoxMesh.new()
	nose_mesh.size = Vector3(1.78, 0.2, 1.05)
	nose.mesh = nose_mesh
	nose.position = Vector3(0, 0.57, -1.12)
	nose.material_override = body_material
	preview_car.add_child(nose)

	var cabin := MeshInstance3D.new()
	var cabin_mesh := BoxMesh.new()
	cabin_mesh.size = Vector3(1.35, 0.43, 1.55)
	cabin.mesh = cabin_mesh
	cabin.position = Vector3(0, 0.88, 0.12)
	var glass_material := StandardMaterial3D.new()
	glass_material.albedo_color = Color(0.035, 0.055, 0.08)
	glass_material.metallic = 0.25
	glass_material.roughness = 0.18
	cabin.material_override = glass_material
	preview_car.add_child(cabin)

	for x in [-1.0, 1.0]:
		for z in [-1.2, 1.2]:
			var wheel := MeshInstance3D.new()
			var wheel_mesh := CylinderMesh.new()
			wheel_mesh.top_radius = 0.34
			wheel_mesh.bottom_radius = 0.34
			wheel_mesh.height = 0.22
			wheel.mesh = wheel_mesh
			wheel.rotation_degrees.z = 90
			wheel.position = Vector3(x, 0.22, z)
			var wheel_material := StandardMaterial3D.new()
			wheel_material.albedo_color = Color(0.018, 0.02, 0.025)
			wheel.material_override = wheel_material
			preview_car.add_child(wheel)

	var spoiler := MeshInstance3D.new()
	var spoiler_mesh := BoxMesh.new()
	spoiler_mesh.size = Vector3(1.65, 0.08, 0.28)
	spoiler.mesh = spoiler_mesh
	spoiler.position = Vector3(0, 0.88, 1.65)
	spoiler.material_override = body_material
	preview_car.add_child(spoiler)

func _start_race() -> void:
	if cars.is_empty():
		return
	var game_state := get_node_or_null("/root/DeathRaceState")
	if game_state != null:
		game_state.set("selected_car_id", String(cars[selected_index].get("id", "lamborghini_veneno")))
	var change_error := get_tree().change_scene_to_file("res://scenes/race.tscn")
	if change_error != OK:
		push_error("Could not open the race scene. Error code: %d" % change_error)
