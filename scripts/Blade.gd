extends Node2D

const MAX_RADIUS := 300
const MIN_RADIUS := 150

const MAX_ANGULAR_SPEED := PI/12

const BLADE_SPEED_FACTOR := 40 

export (int) var radius := 200
export (int) var radial_speed := 10

export (float) var angular_pos := 0.0
export (float) var angular_speed_index := 0.0
export (float) var angular_speed_index_speed := 0.001
export (float) var angular_speed_index_turning_speed := 0.008
export (float) var angular_speed_index_damp := 0.001

onready var blade_target := $BladeTarget as Sprite
onready var blade_node := $Blade as KinematicBody2D

var target_pos := polar2cartesian(radius, angular_pos) as Vector2
var blade_angle := 0.0

func _get_input() -> void:
	if Input.is_action_pressed('rotate_left'):
		if angular_speed_index > 0:
			angular_speed_index += angular_speed_index_speed
		else:
			angular_speed_index += angular_speed_index_turning_speed
	elif Input.is_action_pressed('rotate_right'):
		if angular_speed_index < 0:
			angular_speed_index -= angular_speed_index_speed
		else:
			angular_speed_index -= angular_speed_index_turning_speed
	else:
		if abs(angular_speed_index) < 0.001:
			angular_speed_index = 0.0
		elif angular_speed_index > 0:
			angular_speed_index -= angular_speed_index_damp
		else:
			angular_speed_index += angular_speed_index_damp
	
	if Input.is_action_pressed('push_out'):
		radius += radial_speed
	if Input.is_action_pressed('pull_in'):
		radius -= radial_speed
	
	angular_speed_index = _limit_speed_index(angular_speed_index)
	var angular_speed := _get_angular_speed(abs(angular_speed_index))
	if angular_speed_index < 0.0:
		angular_speed *= -1
	angular_pos += angular_speed
	
	radius = _limit_radius(radius)


func _physics_process(_delta) -> void:
	_get_input()
	_update_blade_target()
	_move_blade()
	_rotate_blade()
	update()


func _draw() -> void:
	draw_arc(Vector2(0,0), MIN_RADIUS, 0, 2 * PI, 100, Color(1,1,1,0.5), 1, false)
	draw_arc(Vector2(0,0), radius, 0, 2 * PI, 100, Color(1,1,1), 3, false)
	draw_arc(Vector2(0,0), MAX_RADIUS, 0, 2 * PI, 100, Color(1,1,1,0.5), 1, false)


func _limit_radius(r: int) -> int:
	return max(min(MAX_RADIUS, r), MIN_RADIUS) as int


func _limit_speed_index(i : float) -> float:
	return max(min(1, i), -1)


# Returns the angular speed of the blade based on a position on the easeOutQuart
# curve. Curve gotten from https://easings.net/#easeOutQuart
func _get_angular_speed(i: float) -> float:
	return (1 - pow(1 - i, 4)) * MAX_ANGULAR_SPEED


func _move_blade() -> void:
	blade_node.move_and_slide((target_pos - blade_node.position) * BLADE_SPEED_FACTOR)


func _rotate_blade() -> void:
	if (target_pos - blade_node.position).length() > 5:
		blade_angle = target_pos.angle_to_point(blade_node.position)
	else:
		var angle_diff := Utils.get_angle_diff(angular_pos, blade_angle)
		
		if abs(angle_diff) < PI / 24:
			blade_angle = angular_pos
		elif angle_diff > 0:
			blade_angle -= PI/12
		elif angle_diff < 0:
			blade_angle += PI/12
	
	# Keep angles within [0, 2*PI]
	angular_pos = fposmod(angular_pos, 2 * PI)
	blade_angle = fposmod(blade_angle, 2 * PI)
	
	blade_node.set_global_rotation(blade_angle)


func _update_blade_target() -> void:
	target_pos = polar2cartesian(radius, angular_pos)
	blade_target.set_position(target_pos)
