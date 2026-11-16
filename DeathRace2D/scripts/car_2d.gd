extends CharacterBody2D
class_name DeathRace2DCar
@export var paint: Color = Color(0.08, 0.48, 0.95)
@export var is_ai: bool = false
@export var top_speed: float = 560.0
@export var acceleration: float = 420.0
@export var braking: float = 720.0
@export var steering: float = 2.7
var speed: float = 0.0
var nitro: float = 100.0
var controls: Dictionary = {"accelerate": false, "brake": false, "left": false, "right": false, "nitro": false, "drift": false}
var route: PackedVector2Array = PackedVector2Array()
var route_index: int = 0
var ai_skill: float = 0.88
var race_enabled: bool = false
var drifting: bool = false
func _ready() -> void:
	collision_layer = 1
	collision_mask = 0
	queue_redraw()
func set_control(action: String, pressed: bool) -> void:
	if controls.has(action):
		controls[action] = pressed
func _physics_process(delta: float) -> void:
	if not race_enabled:
		velocity = Vector2.ZERO
		return
	var throttle := 0.0
	var steer := 0.0
	var boosting := false
	drifting = false
	if is_ai:
		var ai := _get_ai_input()
		throttle = ai.x
		steer = ai.y
	else:
		throttle = float(controls["accelerate"] or Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP))
		if controls["brake"] or Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
			throttle = -0.65
		steer = float(controls["right"] or Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT)) - float(controls["left"] or Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT))
		boosting = controls["nitro"] or Input.is_key_pressed(KEY_SHIFT)
		drifting = controls["drift"] or Input.is_key_pressed(KEY_SPACE)
	if throttle > 0.0:
		speed = move_toward(speed, top_speed * (ai_skill if is_ai else 1.0), acceleration * delta)
	elif throttle < 0.0:
		speed = move_toward(speed, -top_speed * 0.22, braking * delta)
	else:
		speed = move_toward(speed, 0.0, 95.0 * delta)
	var speed_ratio := clampf(absf(speed) / top_speed, 0.0, 1.0)
	var steering_power := steering * (0.18 + speed_ratio * 0.82)
	if drifting:
		steering_power *= 1.3
	rotation += steer * steering_power * delta * signf(speed if absf(speed) > 1.0 else 1.0)
	if boosting and throttle > 0.0 and nitro > 0.0 and not is_ai:
		speed = minf(speed + 260.0 * delta, top_speed * 1.32)
		nitro = maxf(0.0, nitro - 34.0 * delta)
	else:
		nitro = minf(100.0, nitro + 9.0 * delta)
	velocity = Vector2.UP.rotated(rotation) * speed
	move_and_slide()
	queue_redraw()
func _get_ai_input() -> Vector2:
	if route.is_empty():
		return Vector2(0.7, 0.0)
	var target := route[route_index]
	if global_position.distance_to(target) < 58.0:
		route_index = (route_index + 1) % route.size()
		target = route[route_index]
	var desired := (target - global_position).angle()
	var difference := wrapf(desired - (rotation - PI / 2.0), -PI, PI)
	return Vector2(ai_skill, clampf(difference * 1.8, -1.0, 1.0))
func _draw() -> void:
	draw_rect(Rect2(-19, -25, 9, 17), Color(0.025, 0.025, 0.03))
	draw_rect(Rect2(10, -25, 9, 17), Color(0.025, 0.025, 0.03))
	draw_rect(Rect2(-19, 9, 9, 17), Color(0.025, 0.025, 0.03))
	draw_rect(Rect2(10, 9, 9, 17), Color(0.025, 0.025, 0.03))
	draw_colored_polygon(PackedVector2Array([Vector2(-15, 29), Vector2(-19, 13), Vector2(-17, -19), Vector2(-10, -29), Vector2(10, -29), Vector2(17, -19), Vector2(19, 13), Vector2(15, 29)]), paint)
	draw_colored_polygon(PackedVector2Array([Vector2(-11, -10), Vector2(-8, -23), Vector2(8, -23), Vector2(11, -10), Vector2(10, 3), Vector2(-10, 3)]), Color(0.08, 0.13, 0.18))
	draw_colored_polygon(PackedVector2Array([Vector2(-10, 8), Vector2(10, 8), Vector2(12, 19), Vector2(-12, 19)]), Color(0.12, 0.2, 0.25))
	draw_circle(Vector2(-10, -25), 3.0, Color(1.0, 0.92, 0.55))
	draw_circle(Vector2(10, -25), 3.0, Color(1.0, 0.92, 0.55))
