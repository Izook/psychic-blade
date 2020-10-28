extends Node2D

const MAX_RADIUS = 300
const MIN_RADIUS = 150

var radius = 200
var radial_speed = 10

var angular_pos = 0
var angular_speed = PI/36

var polar_pos = polar2cartesian(radius, angular_pos)
var blade_angle = 0

var blade_moved = false


func _limit_radius(r):
	if r > MAX_RADIUS:
		r = MAX_RADIUS
	if r < MIN_RADIUS:
		r = MIN_RADIUS
	return r


func _get_input():
	if Input.is_action_pressed('rotate_left'):
		angular_pos -= angular_speed
	if Input.is_action_pressed('rotate_right'):
		angular_pos += angular_speed
	if Input.is_action_pressed('push_out'):
		radius += radial_speed
	if Input.is_action_pressed('pull_in'):
		radius -= radial_speed
		
	radius = _limit_radius(radius)


func _move_blade():
	polar_pos = polar2cartesian(radius, angular_pos)
	
	if (polar_pos - $Blade.position).length() > 15:
		blade_angle = polar_pos.angle_to_point($Blade.position)
	else:
		var curr_blade_angle = fposmod($Blade.get_global_rotation(), 2 * PI)
		var angle_diff = fposmod(int(angular_pos - curr_blade_angle), 2 * PI)
		if abs(angle_diff) < PI / 24 || (angle_diff / PI) == float(2):
			blade_angle = angular_pos
		elif (angular_pos - curr_blade_angle) > 0:
			blade_angle = fposmod(curr_blade_angle - PI/16, 2 * PI)
		else:
			blade_angle = fposmod(curr_blade_angle + PI/16, 2 * PI)

	
	# Keep angular_pos within [0, 2*PI]
	angular_pos = fposmod(angular_pos, 2 * PI)
	
	$Blade.set_global_rotation(blade_angle)
	$Blade.move_and_slide((polar_pos - $Blade.position) * 4)


func _physics_process(_delta):
	_get_input()
	_move_blade()
