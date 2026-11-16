extends Node2D
const CAR_SCRIPT = preload("res://scripts/car_2d.gd")
const CENTER := Vector2(640, 350)
const RX := 440.0
const RY := 255.0
const ROAD_WIDTH := 150.0
const TOTAL_LAPS := 3
var player: DeathRace2DCar
var rivals: Array[DeathRace2DCar] = []
var route: PackedVector2Array = PackedVector2Array()
var checkpoint_points: Array[Vector2] = []
var next_checkpoint: int = 1
var lap: int = 1
var countdown: float = 3.0
var elapsed: float = 0.0
var race_started: bool = false
var finished: bool = false
var speed_label: Label
var lap_label: Label
var status_label: Label
var nitro_bar: ProgressBar
var touch_layer: Control
func _ready() -> void:
	_make_route()
	_make_cars()
	_make_hud()
	queue_redraw()
func _process(delta: float) -> void:
	if player == null:
		return
	if not race_started and not finished:
		countdown -= delta
		status_label.text = "GET READY  %d" % maxi(1, ceili(countdown)) if countdown > 0.0 else "GO!"
		if countdown <= 0.0:
			race_started = true
			player.race_enabled = true
			for rival in rivals:
				rival.race_enabled = true
			status_label.text = "RACE ON!"
	if race_started and not finished:
		elapsed += delta
		_check_checkpoint()
		speed_label.text = "%03d KM/H" % roundi(absf(player.speed) * 0.42)
		lap_label.text = "LAP  %d / %d" % [mini(lap, TOTAL_LAPS), TOTAL_LAPS]
		nitro_bar.value = player.nitro
func _make_route() -> void:
	for i in range(48):
		var angle := -PI / 2.0 + TAU * float(i) / 48.0
		route.append(CENTER + Vector2(cos(angle) * RX, sin(angle) * RY))
	for i in range(8):
		var angle := -PI / 2.0 + TAU * float(i) / 8.0
		checkpoint_points.append(CENTER + Vector2(cos(angle) * RX, sin(angle) * RY))
func _make_cars() -> void:
	player = _spawn_car("PLAYER", Vector2(640, 94), Color(0.08, 0.48, 0.98), false)
	player.rotation = PI / 2.0
	var specs := [
		[Vector2(584, 94), Color(0.92, 0.12, 0.09), 0.88],
		[Vector2(696, 94), Color(1.0, 0.66, 0.08), 0.91],
		[Vector2(640, 145), Color(0.9, 0.92, 0.96), 0.86]
	]
	for spec in specs:
		var rival := _spawn_car("RIVAL", spec[0], spec[1], true)
		rival.ai_skill = spec[2]
		rival.rotation = PI / 2.0
		rivals.append(rival)
func _spawn_car(label_text: String, pos: Vector2, color: Color, ai: bool) -> DeathRace2DCar:
	var car := DeathRace2DCar.new()
	car.name = label_text
	car.position = pos
	car.paint = color
	car.is_ai = ai
	car.route = route
	add_child(car)
	return car
func _make_hud() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	touch_layer = Control.new()
	touch_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(touch_layer)
	speed_label = _label("000 KM/H", Vector2(28, 18), Vector2(300, 58), 34)
	lap_label = _label("LAP 1 / 3", Vector2(540, 18), Vector2(220, 52), 26)
	lap_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label = _label("GET READY  3", Vector2(420, 78), Vector2(440, 56), 30)
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	nitro_bar = ProgressBar.new()
	nitro_bar.position = Vector2(480, 140)
	nitro_bar.size = Vector2(320, 20)
	nitro_bar.max_value = 100
	nitro_bar.value = 100
	nitro_bar.show_percentage = false
	touch_layer.add_child(nitro_bar)
	_touch_button("LEFT", Rect2(24, 550, 112, 112), "left")
	_touch_button("RIGHT", Rect2(148, 550, 112, 112), "right")
	_touch_button("BRAKE", Rect2(850, 575, 105, 90), "brake")
	_touch_button("DRIFT", Rect2(966, 575, 105, 90), "drift")
	_touch_button("GAS", Rect2(1082, 520, 170, 145), "accelerate")
	_touch_button("NITRO", Rect2(1082, 370, 150, 112), "nitro")
func _label(value: String, pos: Vector2, size: Vector2, font_size: int) -> Label:
	var label := Label.new()
	label.text = value
	label.position = pos
	label.size = size
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color.WHITE)
	label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.9))
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 2)
	touch_layer.add_child(label)
	return label
func _touch_button(caption: String, rect: Rect2, action: String) -> void:
	var button := Button.new()
	button.text = caption
	button.position = rect.position
	button.size = rect.size
	button.add_theme_font_size_override("font_size", 19)
	button.modulate = Color(1, 1, 1, 0.88)
	button.button_down.connect(Callable(player, "set_control").bind(action, true))
	button.button_up.connect(Callable(player, "set_control").bind(action, false))
	touch_layer.add_child(button)
func _check_checkpoint() -> void:
	if player.global_position.distance_to(checkpoint_points[next_checkpoint]) < 72.0:
		next_checkpoint += 1
		if next_checkpoint >= checkpoint_points.size():
			next_checkpoint = 0
			lap += 1
			if lap > TOTAL_LAPS:
				finished = true
				race_started = false
				player.race_enabled = false
				status_label.text = "FINISH!  %.1f SEC" % elapsed
func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, Vector2(1280, 720)), Color(0.12, 0.34, 0.17))
	draw_colored_polygon(_ellipse_points(RX + ROAD_WIDTH * 0.55, RY + ROAD_WIDTH * 0.55), Color(0.88, 0.88, 0.84))
	draw_colored_polygon(_ellipse_points(RX - ROAD_WIDTH * 0.55, RY - ROAD_WIDTH * 0.55), Color(0.12, 0.34, 0.17))
	draw_polyline(_ellipse_points(RX, RY), Color(0.22, 0.23, 0.25), ROAD_WIDTH, true)
	draw_polyline(_ellipse_points(RX + ROAD_WIDTH * 0.52, RY + ROAD_WIDTH * 0.52), Color(0.95, 0.95, 0.92), 5.0, true)
	draw_polyline(_ellipse_points(RX - ROAD_WIDTH * 0.52, RY - ROAD_WIDTH * 0.52), Color(0.95, 0.95, 0.92), 5.0, true)
	draw_polyline(_ellipse_points(RX, RY), Color(0.88, 0.78, 0.28), 3.0, true)
	for i in range(48):
		if i % 2 == 0:
			var angle := -PI / 2.0 + TAU * float(i) / 48.0
			var p := CENTER + Vector2(cos(angle) * RX, sin(angle) * RY)
			var tangent := Vector2(-sin(angle) * RX, cos(angle) * RY).normalized()
			draw_line(p - tangent * 13.0, p + tangent * 13.0, Color(0.95, 0.93, 0.82), 3.0)
	for i in range(8):
		var x := 606.0 + float(i) * 9.0
		draw_rect(Rect2(x, 90, 9, 12), Color.WHITE if i % 2 == 0 else Color.BLACK)
func _ellipse_points(rx: float, ry: float) -> PackedVector2Array:
	var points := PackedVector2Array()
	for i in range(97):
		var angle := TAU * float(i) / 96.0
		points.append(CENTER + Vector2(cos(angle) * rx, sin(angle) * ry))
	return points
