extends KinematicBody2D

class_name Player

signal player_died

const MIN_ZOOM := 0.25
const MAX_ZOOM := 1.25
const ZOOM_SPEED := 0.6

const SPEED := 150

const DASH_SPEED := 750
const DASH_DURATION := 0.1
const DASH_COOLDOWN_DURATION := 1.0
const MAX_DASHES := 2

const HIT_STUN_SPEED := 100
const HIT_STUN_DURATION := 1.0
const INVULNERABILITY_DURATION := 0.5

enum PlayerState {DEFAULT, HITSTUNNED, INVULNERABLE, DASHING}

onready var blade := $Blade as Blade
onready var camera := $PlayerCamera as Camera2D
onready var player_sprite := $PlayerSprite as PlayerSprite

onready var dash_particles := $DashParticles as Particles2D
onready var dash_timer := $DashTimer as Timer
onready var dash_cooldown_timer := $DashCooldownTimer as Timer
onready var dash_sound_player := $Audio/DashSoundPlayer as AudioStreamPlayer2D

onready var player_hit_sound_player := $Audio/PlayerHitSoundPlayer as AudioStreamPlayer2D
onready var hit_stun_timer := $HitStunTimer as Timer
onready var invulnerability_timer := $InvulnerabilityTimer as Timer

var player_state = PlayerState.DEFAULT
var velocity := Vector2()
var camera_zoom := 0.5

var health := 3

var dash_velocity := Vector2()
var dashes := 2

var hit_stun_velocity := Vector2()

func _ready() -> void:
	camera.make_current()
	var _error := connect("player_died", get_node(Utils.MAIN_PATH), "_on_Player_player_died")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed('dash'):
			_handle_dash_request()


func _get_input(delta: float) -> void:
	velocity = Vector2()
	
	if Input.is_action_pressed('move_right'):
		velocity.x += Input.get_action_strength("move_right")
	if Input.is_action_pressed('move_left'):
		velocity.x -= Input.get_action_strength("move_left")
	if Input.is_action_pressed('move_down'):
		velocity.y += Input.get_action_strength("move_down")
	if Input.is_action_pressed('move_up'):
		velocity.y -= Input.get_action_strength("move_up")
	
	if Input.is_action_pressed('zoom_out'):
		camera_zoom += ZOOM_SPEED * delta
	if Input.is_action_pressed('zoom_in'):
		camera_zoom -= ZOOM_SPEED * delta
	
	velocity = velocity.normalized() * SPEED
	
	camera_zoom = _limit_zoom(camera_zoom)


func _handle_dash_request() -> void:
	var input_velocity = velocity.normalized()
	if player_state == PlayerState.DEFAULT and dashes > 0 and input_velocity.length() > 0:
		player_state = PlayerState.DASHING
		dash_velocity = input_velocity *  DASH_SPEED
		dashes = dashes - 1
		
		dash_particles.emitting = true
		dash_sound_player.play()
		
		dash_timer.start(DASH_DURATION)
		if dash_cooldown_timer.is_stopped():
			dash_cooldown_timer.start(DASH_COOLDOWN_DURATION)


func _physics_process(delta: float) -> void:
	_get_input(delta)
	_move_player()
	_handle_collisions()
	_update_zoom()


func _move_player() -> void:
	
	match player_state:
		PlayerState.DEFAULT, PlayerState.INVULNERABLE:
			var _new_velocity := move_and_slide(velocity)
			player_sprite.move_towards(velocity)
		PlayerState.DASHING:
			var _new_velocity := move_and_slide(dash_velocity)
			player_sprite.move_towards(dash_velocity)
		PlayerState.HITSTUNNED:
			var _new_velocity := move_and_slide(hit_stun_velocity)
			player_sprite.hitstun()


func _handle_collisions() -> void:
	for i in get_slide_count():
		var collision := get_slide_collision(i) as KinematicCollision2D
		if collision:
			var enemy := collision.collider as Enemy
			if enemy:
				_handle_hit(collision)


func _handle_hit(collision: KinematicCollision2D) -> void:
	if player_state != PlayerState.HITSTUNNED and player_state != PlayerState.INVULNERABLE:
		health = health - 1
		
		player_state = PlayerState.HITSTUNNED
		player_hit_sound_player.play()
		hit_stun_velocity = collision.normal.normalized() * HIT_STUN_SPEED
		dash_timer.stop()
		hit_stun_timer.start(HIT_STUN_DURATION)
		
		if health == 0:
			_die()


func _die() -> void:
	player_sprite.visible = false
	emit_signal("player_died")


func _update_zoom() -> void:
	camera.set_zoom(Vector2(camera_zoom, camera_zoom))


func _limit_zoom(z: float) -> float:
	if z > MAX_ZOOM:
		z = MAX_ZOOM
	if z < MIN_ZOOM:
		z = MIN_ZOOM
	return z


func _on_DashTimer_timeout() -> void:
	player_state = PlayerState.DEFAULT


func _on_DashCooldownTimer_timeout() -> void:
	dashes = dashes + 1
	if dashes < MAX_DASHES:
		dash_cooldown_timer.start(DASH_COOLDOWN_DURATION)


func get_blade_node() -> Blade:
	return blade


func _on_HitStunTimer_timeout() -> void:
	player_state = PlayerState.INVULNERABLE
	invulnerability_timer.start(INVULNERABILITY_DURATION)
	player_sprite.scale = Vector2(0.5, 0.5)


func _on_InvulnerabilityTimer_timeout() -> void:
	player_sprite.scale = Vector2(1, 1)
	player_state = PlayerState.DEFAULT
