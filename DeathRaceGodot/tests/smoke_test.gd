extends SceneTree

const CAR_CATALOG = preload("res://scripts/car_catalog.gd")

func _initialize() -> void:
	call_deferred("_run_smoke_test")

func _fail(message: String) -> void:
	push_error("SMOKE TEST FAILED: " + message)
	quit(1)

func _run_smoke_test() -> void:
	if String(ProjectSettings.get_setting("application/run/main_scene")) != "res://scenes/garage.tscn":
		_fail("project main scene is not the garage")
		return
	var catalog := CAR_CATALOG.all_cars()
	if catalog.size() != 6:
		_fail("expected 6 catalogue entries, found %d" % catalog.size())
		return
	var catalogue_names: Array[String] = []
	for definition in catalog:
		catalogue_names.append(String(definition.get("display_name", "")))
	if not catalogue_names.has("Lamborghini Veneno") or not catalogue_names.has("Apollo Evo"):
		_fail("Lamborghini and Apollo catalogue entries are missing")
		return

	var state_node := root.get_node_or_null("DeathRaceState")
	if state_node == null:
		var state_script := load("res://scripts/game_state.gd") as Script
		state_node = state_script.new() as Node
		state_node.name = "DeathRaceState"
		root.add_child(state_node)
	state_node.set("selected_car_id", "apollo_evo")

	var garage_scene := load("res://scenes/garage.tscn") as PackedScene
	if garage_scene == null:
		_fail("could not load the garage scene")
		return
	var garage_root := garage_scene.instantiate() as Control
	if garage_root == null:
		_fail("garage root is not a Control")
		return
	root.add_child(garage_root)
	await process_frame
	var garage_cars: Array = garage_root.get("cars")
	if garage_cars.size() != 6:
		_fail("garage did not build all 6 cars")
		return
	var garage_preview := garage_root.get("preview_car") as Node3D
	var start_button := garage_root.get("start_race_button") as Button
	if garage_preview == null or start_button == null:
		_fail("garage preview or Start Race button is missing")
		return
	garage_root.call("_select_car", 5)
	var selected_name := garage_root.get("name_label") as Label
	if selected_name == null or selected_name.text != "Apollo Evo":
		_fail("garage selection did not update to Apollo Evo")
		return
	garage_root.queue_free()
	await process_frame

	var packed_scene := load("res://scenes/race.tscn") as PackedScene
	if packed_scene == null:
		_fail("could not load res://scenes/race.tscn")
		return

	var race_root := packed_scene.instantiate() as Node3D
	if race_root == null:
		_fail("main scene root is not Node3D")
		return

	root.add_child(race_root)
	await process_frame

	var player := race_root.get_node_or_null("Player") as DeathRaceCar
	if player == null:
		_fail("Player node or DeathRaceCar script is missing")
		return
	if absf(player.max_speed - (365.0 / 3.6)) > 0.1:
		_fail("selected Apollo Evo performance was not applied to the player")
		return

	var rivals := get_nodes_in_group("rivals")
	if rivals.size() != 3:
		_fail("expected 3 AI rivals, found %d" % rivals.size())
		return

	var camera := race_root.get("follow_camera") as Camera3D
	if camera == null or not camera.current:
		_fail("active chase camera is missing")
		return

	await create_timer(3.25).timeout
	if not bool(race_root.get("race_started")) or not player.race_enabled:
		_fail("race did not start after countdown")
		return
	if int(race_root.get("next_checkpoint")) != 1:
		_fail("player did not register the start-line checkpoint")
		return

	var rival_start_positions: Array[Vector3] = []
	for rival_node in rivals:
		var rival := rival_node as DeathRaceCar
		if rival == null:
			_fail("a rival is missing the DeathRaceCar script")
			return
		rival_start_positions.append(rival.global_position)

	player.set_control("accelerate", true)
	player.set_control("nitro", true)
	await create_timer(0.65).timeout
	player.set_control("accelerate", false)
	player.set_control("nitro", false)
	if player.linear_velocity.length() < 3.0:
		_fail("player acceleration did not produce forward speed")
		return
	if player.nitro >= 99.5:
		_fail("nitro did not drain while boosting")
		return

	var forward_before := -player.global_transform.basis.z
	player.set_control("right", true)
	await create_timer(0.45).timeout
	player.set_control("right", false)
	var forward_after := -player.global_transform.basis.z
	if forward_after.z <= forward_before.z + 0.01:
		_fail("right steering did not turn the car toward its right")
		return

	var ai_moved := false
	for index in range(rivals.size()):
		var rival := rivals[index] as DeathRaceCar
		if rival.global_position.distance_to(rival_start_positions[index]) > 0.5:
			ai_moved = true
			break
	if not ai_moved:
		_fail("AI rivals did not move after the race started")
		return

	print("SMOKE TEST PASSED: scene, camera, countdown, start checkpoint, acceleration, nitro, right steering and AI movement.")
	quit(0)
