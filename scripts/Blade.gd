extends Node2D

const MAX_RADIUS = 300
const MIN_RADIUS = 100

var polar_vector

var radius = 200
var radial_speed = 10

var angle = 0
var angular_speed = PI/48


func _limit_radius(r):
	if r > MAX_RADIUS:
		r = MAX_RADIUS
	if r < MIN_RADIUS:
		r = MIN_RADIUS
	return r


func _get_input():
	if Input.is_action_pressed('rotate_left'):
		angle -= angular_speed
	if Input.is_action_pressed('rotate_right'):
		angle += angular_speed
	if Input.is_action_pressed('push_out'):
		radius += radial_speed
	if Input.is_action_pressed('pull_in'):
		radius -= radial_speed
		
	radius = _limit_radius(radius)


func _physics_process(delta):
	_get_input()
	polar_vector = polar2cartesian(radius, angle)
	$Blade.set_position(polar_vector)

