extends Node2D

class_name Blade

const MAX_RADIUS := 175
const MIN_RADIUS := 50
const RADIAL_SPEED := 600.0

const MAX_ANGULAR_SPEED := 2.5 * PI
const ANGULAR_SPEED_INDEX_POS_DELTA := 0.001
const ANGULAR_SPEED_INDEX_NEG_DELTA := 0.008
const ANGULAR_SPEED_INDEX_DAMP := 0.001

const BLADE_SPEED_FACTOR := 40 
const BLADE_ROTATIONAL_SPEED := PI/10

const RELEASED_BLADE_DAMP := 0.99

const BLADE_RETRIEVAL_COOLDOWN := 0.5

const MAX_FRAMES_PER_SECOND := 60.0

enum BladeState {HELD, RELEASED, RETURNING}

const RETURNING_BLADE_COLOR := Color(1, 0, 0)
const RELEASED_BLADE_COLOR := Color(0, 1, 0)
const HELD_BLADE_COLOR := Color(1, 0, 1)
const PARTICLE_COLOR_GRADIENT_PATHS := {
	BladeState.HELD: "res://scenes/blade/particle_gradients/held_particles.tres",
	BladeState.RELEASED: "res://scenes/blade/particle_gradients/released_particles.tres",
	BladeState.RETURNING: "res://scenes/blade/particle_gradients/returning_particles.tres"
}

const IMPACT_EFFECT_SCENE = preload("res://scenes/blade/impact_effect/impact_effect.tscn")

onready var blade_target := $BladeTarget as Sprite
onready var blade_node := $Blade as KinematicBody2D
onready var blade_particles := $Blade/Particles2D as Particles2D
onready var blade_particles_material := blade_particles.get_process_material() as ParticlesMaterial
onready var blade_realease_timer := $BladeReleaseTimer as Timer

onready var wall_hit_sound_player := $Audio/WallHitSoundPlayer as AudioStreamPlayer2D

onready var current_level := get_node(Utils.ACTIVE_LEVEL_PATH)

var angular_pos := 0.0
var angular_speed_index := 0.0
var radius := 100.0
var target_pos := polar2cartesian(radius, angular_pos) as Vector2
var blade_angle := 0.0

var blade_state = BladeState.HELD
var is_blade_retrievable := false
var blade_veclocity := Vector2(0,0)


func _get_input(delta: float) -> void:
	if Input.is_action_pressed('rotate_left'):
		if angular_speed_index > 0:
			angular_speed_index += ANGULAR_SPEED_INDEX_POS_DELTA
		else:
			angular_speed_index += ANGULAR_SPEED_INDEX_NEG_DELTA
	elif Input.is_action_pressed('rotate_right'):
		if angular_speed_index < 0:
			angular_speed_index -= ANGULAR_SPEED_INDEX_POS_DELTA
		else:
			angular_speed_index -= ANGULAR_SPEED_INDEX_NEG_DELTA
	else:
		if abs(angular_speed_index) < 0.001:
			angular_speed_index = 0.0
		elif angular_speed_index > 0:
			angular_speed_index -= ANGULAR_SPEED_INDEX_DAMP
		else:
			angular_speed_index += ANGULAR_SPEED_INDEX_DAMP
	
	angular_speed_index = _limit_speed_index(angular_speed_index)
	var angular_speed := _get_angular_speed(angular_speed_index)
	if blade_state == BladeState.RETURNING:
		angular_speed = angular_speed / 4

	angular_pos += angular_speed * delta
	
	if Input.is_action_pressed('push_out'):
		radius += RADIAL_SPEED * delta
	if Input.is_action_pressed('pull_in'):
		radius -= RADIAL_SPEED * delta
	
	radius = _limit_radius(radius)
	
	if Input.is_action_pressed('toggle_blade_release'):
		if blade_state != BladeState.RELEASED and blade_state != BladeState.RETURNING:
			set_blade_state(BladeState.RELEASED)
			is_blade_retrievable = false
			blade_realease_timer.start(BLADE_RETRIEVAL_COOLDOWN)
		elif is_blade_retrievable:
			set_blade_state(BladeState.RETURNING)


func _physics_process(delta: float) -> void:
	_get_input(delta)
	_update_blade_target()
	_update_blade_appearance()
	
	var new_blade_angle := _move_blade()
	
	_rotate_blade(new_blade_angle)
	
	update()


func _draw() -> void:
	var line_width = 1
	if radius == MIN_RADIUS or radius == MAX_RADIUS:
		line_width = 3
	draw_arc(Vector2(0,0), radius, 0, 2 * PI, 100, Color(1,1,1, 0.5), line_width, false)


func _limit_radius(r: float) -> float:
	return max(min(MAX_RADIUS, r), MIN_RADIUS)


func _limit_speed_index(i : float) -> float:
	return max(min(1, i), -1)


# Returns the angular speed of the blade based on a position on the easeOutQuart
# curve. Curve gotten from https://easings.net/#easeOutQuart
func _get_angular_speed(i: float) -> float:
	var angular_speed := (1 - pow(1 - abs(i), 4)) * MAX_ANGULAR_SPEED
	
	if angular_speed_index < 0.0:
		angular_speed *= -1
	
	return angular_speed



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
	var new_blade_velocity := blade_node.move_and_slide(blade_veclocity)
	
	for i in blade_node.get_slide_count():
		var collision := blade_node.get_slide_collision(i)
		
		var tile_map := collision.collider as TileMap
		if tile_map:
			wall_hit_sound_player.play()
			new_blade_velocity = blade_veclocity.bounce(collision.normal)
	
	blade_veclocity = new_blade_velocity * RELEASED_BLADE_DAMP


func _move_returning_blade() -> void:
	var global_target_pos := (get_global_position() + target_pos)
	var angle_to_target := global_target_pos.angle_to_point(blade_node.get_global_position())
	var new_blade_velocity := Vector2(cos(angle_to_target), sin(angle_to_target))
	new_blade_velocity = new_blade_velocity * get_max_speed() / 2
	
	blade_veclocity = blade_node.move_and_slide(new_blade_velocity)
	
	if ((blade_node.position - global_target_pos).length() < 15):
		set_blade_state(BladeState.HELD)


func impact_entity(entity: Node2D) -> void:
	var impact_effect := IMPACT_EFFECT_SCENE.instance() as Node2D
	impact_effect.global_position = entity.global_position
	current_level.add_child(impact_effect)


func _rotate_blade(new_angle: float) -> void:
	var angle_diff := Utils.get_angle_diff(new_angle, blade_angle) as float
	
	if abs(angle_diff) < BLADE_ROTATIONAL_SPEED / 2:
		blade_angle = new_angle
	elif angle_diff > 0:
		blade_angle -= BLADE_ROTATIONAL_SPEED
	elif angle_diff < 0:
		blade_angle += BLADE_ROTATIONAL_SPEED
	
	# Keep angles within [0, 2*PI]
	angular_pos = fposmod(angular_pos, 2 * PI)
	blade_angle = fposmod(blade_angle, 2 * PI)
	
	blade_node.set_global_rotation(blade_angle + ((3 * PI) / 4))


func _update_blade_target() -> void:
	target_pos = polar2cartesian(radius, angular_pos)
	blade_target.set_position(target_pos)
	
	blade_target.visible = true
	if (blade_target.global_position - blade_node.global_position).length() < 20:
		blade_target.visible = false 


func _update_blade_appearance() -> void:
	blade_particles_material.set_color_ramp(load(PARTICLE_COLOR_GRADIENT_PATHS[blade_state]))


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


func get_max_speed() -> float: 
	return (MAX_ANGULAR_SPEED) * MAX_RADIUS


func get_current_speed() -> float:
	return blade_veclocity.length()


func get_max_angular_speed() -> float: 
	return MAX_ANGULAR_SPEED


func get_current_angular_speed() -> float:
	return _get_angular_speed(angular_speed_index)
