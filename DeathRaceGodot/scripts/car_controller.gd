extends RigidBody3D
class_name DeathRaceCar

@export var acceleration: float = 34.0
@export var reverse_force: float = 15.0
@export var max_speed: float = 54.0
@export var steering_force: float = 8.5
@export var grip: float = 7.0
@export var nitro_force: float = 62.0
@export var is_ai: bool = false
@export var ai_speed: float = 0.82

var nitro: float = 100.0
var controls: Dictionary = {"accelerate": false, "brake": false, "left": false, "right": false, "nitro": false, "drift": false}
var waypoints: Array[Vector3] = []
var waypoint_index: int = 0
var race_enabled: bool = false

func _ready() -> void:
	mass = 1150.0
	gravity_scale = 0.0
	linear_damp = 0.16
	angular_damp = 4.0
	can_sleep = false
	continuous_cd = true

func set_control(action: String, pressed: bool) -> void:
	if controls.has(action):
		controls[action] = pressed

func _physics_process(delta: float) -> void:
	if not race_enabled:
		return

	var throttle := 0.0
	var steer := 0.0
	var boosting := false
	var drifting := false
	if is_ai:
		var ai_input := _get_ai_input()
		throttle = ai_input.x
		steer = ai_input.y
	else:
		throttle = float(controls["accelerate"] or Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP))
		if controls["brake"] or Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
			throttle = -1.0
		steer = float(controls["right"] or Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT)) - float(controls["left"] or Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT))
		boosting = controls["nitro"] or Input.is_key_pressed(KEY_SHIFT)
		drifting = controls["drift"] or Input.is_key_pressed(KEY_SPACE)

	var forward := -global_transform.basis.z
	var right := global_transform.basis.x
	var forward_speed := linear_velocity.dot(forward)
	var speed_factor := clampf(absf(forward_speed) / 18.0, 0.0, 1.0)

	if throttle > 0.0:
		apply_central_force(forward * acceleration * throttle * mass)
	elif throttle < 0.0:
		if forward_speed > 2.0:
			apply_central_force(-forward * reverse_force * mass)
		else:
			apply_central_force(forward * reverse_force * throttle * mass)

	if absf(steer) > 0.01 and speed_factor > 0.03:
		apply_torque(Vector3.UP * steer * steering_force * speed_factor * mass * 0.12 * signf(forward_speed if absf(forward_speed) > 0.5 else 1.0))

	var lateral_speed := linear_velocity.dot(right)
	var active_grip := grip * (0.28 if drifting else 1.0)
	apply_central_force(-right * lateral_speed * active_grip * mass)

	if boosting and throttle > 0.0 and nitro > 0.0:
		apply_central_force(forward * nitro_force * mass)
		nitro = maxf(0.0, nitro - 30.0 * delta)
	else:
		nitro = minf(100.0, nitro + 7.0 * delta)

	var forward_component := forward * linear_velocity.dot(forward)
	var side_component := linear_velocity - forward_component
	var limit := max_speed * (1.32 if boosting and nitro > 0.0 else 1.0)
	if forward_component.length() > limit:
		forward_component = forward_component.normalized() * limit
		linear_velocity = forward_component + side_component

func _get_ai_input() -> Vector2:
	if waypoints.is_empty():
		return Vector2(0.7, 0.0)
	var target := waypoints[waypoint_index]
	var offset := target - global_position
	offset.y = 0.0
	if offset.length() < 9.0:
		waypoint_index = (waypoint_index + 1) % waypoints.size()
		target = waypoints[waypoint_index]
		offset = target - global_position
		offset.y = 0.0
	var local_target := global_transform.basis.inverse() * offset.normalized()
	var angle := atan2(local_target.x, -local_target.z)
	return Vector2(ai_speed, clampf(angle / 0.72, -1.0, 1.0))
