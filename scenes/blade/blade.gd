extends Node2D

const MAX_RADIUS := 300
const MIN_RADIUS := 150

const MAX_ANGULAR_SPEED := 3 * PI / 36
const ANGULAR_SPEED_COEF := PI/24

const BLADE_SPEED_FACTOR := 40 
const BLADE_ROTATIONAL_SPEED := PI/10

const BLADE_RETRIEVAL_COOLDOWN := 0.5

enum BladeState {HELD, RELEASED, RETURNING}

const RETURNING_BLADE_COLOR := Color(1, 0, 0)
const RELEASED_BLADE_COLOR := Color(0, 1, 0)
const HELD_BLADE_COLOR := Color(1, 0, 1)
const BLADE_STATE_COLORS := {
	BladeState.HELD: HELD_BLADE_COLOR,
	BladeState.RELEASED: RELEASED_BLADE_COLOR,
	BladeState.RETURNING: RETURNING_BLADE_COLOR
}

export (int) var radius := 200
export (int) var radial_speed := 10

export (float) var angular_pos := 0.0
export (float) var angular_speed_index := 0.0
export (float) var angular_speed_index_speed := 0.001
export (float) var angular_speed_index_turning_speed := 0.008
export (float) var angular_speed_index_damp := 0.001

onready var blade_target := $BladeTarget as Sprite
onready var blade_node := $Blade as KinematicBody2D
onready var blade_particles := $Blade/Particles2D as Particles2D
onready var blade_particles_material := blade_particles.get_process_material() as ParticlesMaterial
onready var blade_realease_timer = $BladeReleaseTimer as Timer

var target_pos := polar2cartesian(radius, angular_pos) as Vector2
var blade_angle := 0.0

var blade_state = BladeState.HELD
var is_blade_retrievable := false
var blade_veclocity := Vector2(0,0)


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
	
	angular_speed_index = _limit_speed_index(angular_speed_index)
	var angular_speed := _get_angular_speed(abs(angular_speed_index))
	if angular_speed_index < 0.0:
		angular_speed *= -1
	angular_pos += angular_speed
	
	if Input.is_action_pressed('push_out'):
		radius += radial_speed
	if Input.is_action_pressed('pull_in'):
		radius -= radial_speed
	
	radius = _limit_radius(radius)
	
	if Input.is_action_pressed('toggle_blade_release'):
		if blade_state != BladeState.RELEASED and blade_state != BladeState.RETURNING:
			set_blade_state(BladeState.RELEASED)
			is_blade_retrievable = false
			blade_realease_timer.start(BLADE_RETRIEVAL_COOLDOWN)
		elif is_blade_retrievable:
			set_blade_state(BladeState.RETURNING)


func _physics_process(_delta) -> void:
	_get_input()
	_update_blade_target()
	_update_blade_appearance()
	
	var new_blade_angle := _move_blade()
	_rotate_blade(new_blade_angle)
	
	update()


func _draw() -> void:
	draw_arc(Vector2(0,0), MIN_RADIUS, 0, 2 * PI, 100, Color(1,1,1,0.5), 1, false)
	draw_arc(Vector2(0,0), radius, 0, 2 * PI, 100, Color(1,1,1), 2, false)
	draw_arc(Vector2(0,0), MAX_RADIUS, 0, 2 * PI, 100, Color(1,1,1,0.5), 1, false)


func _limit_radius(r: int) -> int:
	return max(min(MAX_RADIUS, r), MIN_RADIUS) as int


func _limit_speed_index(i : float) -> float:
	return max(min(1, i), -1)


# Returns the angular speed of the blade based on a position on the easeOutQuart
# curve. Curve gotten from https://easings.net/#easeOutQuart
func _get_angular_speed(i: float) -> float:
	var angular_speed = min(
			(1 - pow(1 - i, 4)) * ANGULAR_SPEED_COEF * pow(float(MAX_RADIUS) / radius, 1),
			 MAX_ANGULAR_SPEED)
	if blade_state != BladeState.RETURNING:
		return angular_speed
	else:
		return angular_speed / 3


func _move_blade() -> float:
	var new_blade_angle: float
	
	var global_blade_pos := blade_node.get_global_position()
	var global_target_pos := (get_global_position() + target_pos)
	
	match blade_state:
		BladeState.HELD:
			if (target_pos - blade_node.position).length() > 2:
				new_blade_angle = target_pos.angle_to_point(blade_node.position)
			else:
				new_blade_angle = angular_pos
				
			_move_held_blade()
		
		BladeState.RELEASED:			
			new_blade_angle = blade_veclocity.angle()
			
			_move_released_blade()
		
		BladeState.RETURNING:
			new_blade_angle = global_target_pos.angle_to_point(global_blade_pos)
			
			_move_returning_blade()
	
	return new_blade_angle


func _move_held_blade() -> void:
	blade_veclocity = blade_node.move_and_slide((target_pos - blade_node.position) * BLADE_SPEED_FACTOR)


func _move_released_blade() -> void:
	var new_blade_pos := blade_node.position + blade_veclocity
	blade_veclocity = blade_node.move_and_slide(new_blade_pos - blade_node.position)


func _move_returning_blade() -> void:
	var global_target_pos := (get_global_position() + target_pos)
	var angle_to_target := global_target_pos.angle_to_point(blade_node.get_global_position())
	var new_blade_velocity := Vector2(cos(angle_to_target), sin(angle_to_target)) * 1000
	
	blade_veclocity = blade_node.move_and_slide(new_blade_velocity)
	
	if ((blade_node.position - global_target_pos).length() < 15):
		set_blade_state(BladeState.HELD)


func _rotate_blade(new_angle: float) -> void:
	var angle_diff := Utils.get_angle_diff(new_angle, blade_angle)
	
	if abs(angle_diff) < BLADE_ROTATIONAL_SPEED / 2:
		blade_angle = new_angle
	elif angle_diff > 0:
		blade_angle -= BLADE_ROTATIONAL_SPEED
	elif angle_diff < 0:
		blade_angle += BLADE_ROTATIONAL_SPEED
	
	# Keep angles within [0, 2*PI]
	angular_pos = fposmod(angular_pos, 2 * PI)
	blade_angle = fposmod(blade_angle, 2 * PI)
	
	blade_node.set_global_rotation(blade_angle)


func _update_blade_target() -> void:
	target_pos = polar2cartesian(radius, angular_pos)
	blade_target.set_position(target_pos)


func _update_blade_appearance() -> void:
	blade_particles_material.set_color(BLADE_STATE_COLORS[blade_state])


func set_blade_state(new_state: int) -> void:
	match new_state:
		BladeState.HELD:
			blade_node.set_position(target_pos)
			blade_node.set_as_toplevel(false)
		
		BladeState.RELEASED:
			blade_node.set_position(blade_node.get_global_position())
			blade_node.set_as_toplevel(true)
		
		BladeState.RETURNING:
			pass
	
	blade_state = new_state


func _on_BladeReleaseTimer_timeout() -> void:
	is_blade_retrievable = true
