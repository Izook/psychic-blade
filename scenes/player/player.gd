extends KinematicBody2D

class_name Player

signal player_died

const MIN_ZOOM := 1.5
const MAX_ZOOM := 4.0

const DASH_DURATION := 0.075
const DASH_RESET_TIME := 1.0

export (int) var speed := 24000
export (int) var dash_factor := 5
export (float) var zoom_speed := 0.6

onready var camera := $PlayerCamera as Camera2D
onready var dash_particles := $DashParticles as Particles2D
onready var dash_timer := $DashTimer as Timer
onready var dash_reset_timer := $DashResetTimer as Timer
onready var player_sprite := $PlayerSprite as PlayerSprite

var velocity := Vector2()
var zoom_factor := 2.0

var dash_ready := true
var player_dashing := false


func _ready() -> void:
	var _error := connect("player_died", get_node(Utils.MAIN_PATH), "_on_Player_player_died")


func _get_input(delta: float) -> void:
	velocity = Vector2()
	var dash_requested := false
	
	if Input.is_action_pressed('move_right'):
		velocity.x += 1
	if Input.is_action_pressed('move_left'):
		velocity.x -= 1
	if Input.is_action_pressed('move_down'):
		velocity.y += 1
	if Input.is_action_pressed('move_up'):
		velocity.y -= 1
	
	if Input.is_action_pressed('zoom_out'):
		zoom_factor += zoom_speed * delta
	if Input.is_action_pressed('zoom_in'):
		zoom_factor -= zoom_speed * delta
	
	if Input.is_action_pressed('dash'):
		dash_requested = true
	
	velocity = velocity.normalized() * speed * delta
	
	if dash_requested && !player_dashing && dash_ready:
		dash_particles.restart()
		dash_particles.set_emitting(true)
		player_dashing = true
		dash_ready = false
		dash_timer.start(DASH_DURATION)
	
	if player_dashing:
		velocity *= dash_factor
		
	zoom_factor = _limit_zoom(zoom_factor)


func _physics_process(delta: float) -> void:
	_get_input(delta)
	player_sprite.move_towards(velocity)
	var _collision_info := move_and_slide(velocity)
	
	for i in get_slide_count():
			var collision := get_slide_collision(i) as KinematicCollision2D
			if collision:
				var enemy := collision.collider as Enemy
				if enemy:
					player_sprite.visible = false
					emit_signal("player_died")


	camera.set_zoom(Vector2(zoom_factor, zoom_factor))
	camera.make_current()


func _limit_zoom(z: float) -> float:
	if z > MAX_ZOOM:
		z = MAX_ZOOM
	if z < MIN_ZOOM:
		z = MIN_ZOOM
	return z


func _on_DashTimer_timeout() -> void:
	player_dashing = false
	dash_reset_timer.start(DASH_RESET_TIME)


func _on_DashResetTimer_timeout() -> void:
	dash_ready = true


func get_blade_node() -> Node2D:
	return $Blade as Node2D
