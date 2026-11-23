extends SceneTree

func _initialize() -> void:
	call_deferred("_run_smoke_test")

func _fail(message: String) -> void:
	push_error("SMOKE TEST FAILED: " + message)
	quit(1)

func _run_smoke_test() -> void:
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
