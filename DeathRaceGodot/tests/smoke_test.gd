extends SceneTree

func _initialize() -> void:
	call_deferred("_run_smoke_test")

func _run_smoke_test() -> void:
	var packed_scene := load("res://scenes/race.tscn") as PackedScene
	if packed_scene == null:
		push_error("SMOKE TEST FAILED: could not load res://scenes/race.tscn")
		quit(1)
		return

	var race_root := packed_scene.instantiate() as Node3D
	if race_root == null:
		push_error("SMOKE TEST FAILED: main scene root is not Node3D")
		quit(1)
		return

	root.add_child(race_root)
	await process_frame

	var player := race_root.get_node_or_null("Player") as DeathRaceCar
	if player == null:
		push_error("SMOKE TEST FAILED: Player node or DeathRaceCar script is missing")
		quit(1)
		return

	var rivals := get_nodes_in_group("rivals")
	if rivals.size() != 3:
		push_error("SMOKE TEST FAILED: expected 3 AI rivals, found %d" % rivals.size())
		quit(1)
		return

	var camera := race_root.get_node_or_null("Camera3D") as Camera3D
	if camera == null or not camera.current:
		push_error("SMOKE TEST FAILED: active chase camera is missing")
		quit(1)
		return

	await create_timer(3.25).timeout
	if not player.race_enabled:
		push_error("SMOKE TEST FAILED: race did not start after countdown")
		quit(1)
		return

	print("SMOKE TEST PASSED: scene, player, 3 rivals, camera and countdown.")
	quit(0)
