extends Node2D

const MAX_RADIUS := 300
const MIN_RADIUS := 150
const BLADE_SPEED_FACTOR := 20 

export (int) var radius := 200
export (int) var radial_speed := 10

export (float) var angular_pos := 0.0
export (float) var angular_speed := PI/36

var target_pos := polar2cartesian(radius, angular_pos) as Vector2
var blade_angle := 0.0


func _get_input() -> void:
	if Input.is_action_pressed('rotate_left'):
		angular_pos -= angular_speed
	if Input.is_action_pressed('rotate_right'):
		angular_pos += angular_speed
	if Input.is_action_pressed('push_out'):
		radius += radial_speed
	if Input.is_action_pressed('pull_in'):
		radius -= radial_speed
	
	radius = _limit_radius(radius)


func _physics_process(_delta) -> void:
	_get_input()
	_move_blade()
	_update_blade_target()
	update()


func _draw() -> void:
	draw_arc(Vector2(0,0), MIN_RADIUS, 0, 2 * PI, 100, Color(1,1,1,0.5), 1, false)
	draw_arc(Vector2(0,0), radius, 0, 2 * PI, 100, Color(1,1,1), 3, false)
	draw_arc(Vector2(0,0), MAX_RADIUS, 0, 2 * PI, 100, Color(1,1,1,0.5), 1, false)


func _limit_radius(r: int) -> int:
	if r > MAX_RADIUS:
		r = MAX_RADIUS
	if r < MIN_RADIUS:
		r = MIN_RADIUS
	return r


func _move_blade() -> void:
	var blade_node = $Blade as Node2D
	target_pos = polar2cartesian(radius, angular_pos)
	
	if (target_pos - blade_node.position).length() > 15:
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
	blade_node.move_and_slide((target_pos - blade_node.position) * BLADE_SPEED_FACTOR)


func _update_blade_target() -> void:
	var blade_target := $BladeTarget as Node2D
	blade_target.set_position(target_pos)
