extends KinematicBody2D

class_name Player

signal player_died

const MIN_ZOOM := 0.5
const MAX_ZOOM := 1.25
const ZOOM_SPEED := 0.6

const SPEED := 150

const DASH_DURATION := 0.075
const DASH_RESET_TIME := 1.0
const DASH_SPEED_FACTOR := 5

onready var camera := $PlayerCamera as Camera2D
onready var dash_particles := $DashParticles as Particles2D
onready var dash_timer := $DashTimer as Timer
onready var dash_reset_timer := $DashResetTimer as Timer
onready var player_sprite := $PlayerSprite as PlayerSprite

var velocity := Vector2()
var camera_zoom := 0.9

var dash_ready := true
var player_dashing := false


func _ready() -> void:
	var _error := connect("player_died", get_node(Utils.MAIN_PATH), "_on_Player_player_died")


func _get_input(delta: float) -> void:
	velocity = Vector2()
	var dash_requested := false
	
	if Input.is_action_pressed('move_right'):
		velocity.x += 1 * Input.get_action_strength("move_right")
	if Input.is_action_pressed('move_left'):
		velocity.x -= 1 * Input.get_action_strength("move_left")
	if Input.is_action_pressed('move_down'):
		velocity.y += 1 * Input.get_action_strength("move_down")
	if Input.is_action_pressed('move_up'):
		velocity.y -= 1 * Input.get_action_strength("move_up")
	
	if Input.is_action_pressed('zoom_out'):
		camera_zoom += ZOOM_SPEED * delta
	if Input.is_action_pressed('zoom_in'):
		camera_zoom -= ZOOM_SPEED * delta
	
	if Input.is_action_pressed('dash'):
		dash_requested = true
	
	velocity = velocity.normalized() * SPEED
	
	if dash_requested && !player_dashing && dash_ready:
		dash_particles.restart()
		dash_particles.set_emitting(true)
		player_dashing = true
		dash_ready = false
		dash_timer.start(DASH_DURATION)
	
	if player_dashing:
		velocity *= DASH_SPEED_FACTOR
		
	camera_zoom = _limit_zoom(camera_zoom)


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


	camera.set_zoom(Vector2(camera_zoom, camera_zoom))
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
