extends Node2D

const MAX_RADIUS := 300
const MIN_RADIUS := 150

export (int) var radius := 200
export (int) var radial_speed := 10

export (float) var angular_pos := 0.0
export (float) var angular_speed := PI/36

var polar_pos := polar2cartesian(radius, angular_pos) as Vector2
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


func _limit_radius(r: int) -> int:
	if r > MAX_RADIUS:
		r = MAX_RADIUS
	if r < MIN_RADIUS:
		r = MIN_RADIUS
	return r


func _move_blade() -> void:
	var blade_node = $Blade as Node2D
	polar_pos = polar2cartesian(radius, angular_pos)
	
	if (polar_pos - blade_node.position).length() > 15:
		blade_angle = polar_pos.angle_to_point(blade_node.position)
	else:
		var curr_blade_angle: float = fposmod(
				blade_node.get_global_rotation(), 2 * PI)
		var angle_diff: float = fposmod(
				int(angular_pos - curr_blade_angle), 2 * PI)
		
		if abs(angle_diff) < PI / 24 || (angle_diff / PI) == float(2):
			blade_angle = angular_pos
		elif (angular_pos - curr_blade_angle) > 0:
			blade_angle = fposmod(curr_blade_angle - PI/16, 2 * PI)
		else:
			blade_angle = fposmod(curr_blade_angle + PI/16, 2 * PI)
	
	# Keep angular_pos within [0, 2*PI]
	angular_pos = fposmod(angular_pos, 2 * PI)
	
	blade_node.set_global_rotation(blade_angle)
	blade_node.move_and_slide((polar_pos - blade_node.position) * 4)
