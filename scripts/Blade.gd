extends Node2D

const MAX_RADIUS = 300
const MIN_RADIUS = 150

var polar_vector
var blade_angle

var radius = 200
var radial_speed = 10

var anglular_pos = 0
var angular_speed = PI/36

var blade_moved = false


func _limit_radius(r):
	if r > MAX_RADIUS:
		r = MAX_RADIUS
	if r < MIN_RADIUS:
		r = MIN_RADIUS
	return r


func _get_input():
	if Input.is_action_pressed('rotate_left'):
		anglular_pos -= angular_speed
	if Input.is_action_pressed('rotate_right'):
		anglular_pos += angular_speed
	if Input.is_action_pressed('push_out'):
		radius += radial_speed
	if Input.is_action_pressed('pull_in'):
		radius -= radial_speed
		
	radius = _limit_radius(radius)


func _move_blade():
	polar_vector = polar2cartesian(radius, anglular_pos)
	
	if $Blade.position != polar_vector:
		blade_angle = $Blade.position.angle_to_point(polar_vector)
		$Blade.set_global_rotation(blade_angle + PI)
	else:
		$Blade.set_global_rotation(anglular_pos)
	
	$Blade.move_and_slide((polar_vector - $Blade.position) * 4)


func _physics_process(_delta):
	_get_input()
	_move_blade()
