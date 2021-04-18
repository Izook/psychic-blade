extends KinematicBody2D

class_name Player

signal died
signal health_changed(new_health)
signal dashes_changed(new_dashes)

const MIN_ZOOM := 0.25
const MAX_ZOOM := 1.25
const ZOOM_SPEED := 0.6

const SPEED := 150

const MAX_HEALTH := 3

const DEFAULT_MODULATE := Color("ffffff")

const DASH_SPEED := 750
const DASH_DURATION := 0.1
const DASH_COOLDOWN_DURATION := 1.0
const MAX_DASHES := 2

const HIT_STUN_SPEED := 100
const HIT_STUN_DURATION := 1.0
const HIT_STUNNED_MODULATE := Color("ff7e7e")

const INVULNERABILITY_DURATION := 0.5
const INVULNERABILITY_MODULATE := Color("7effffff")

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
var camera_zoom := 0.75

var health := 3

var dash_velocity := Vector2()
var dashes := 2

var hit_stun_velocity := Vector2()

func _ready() -> void:
	camera.make_current()
	var _error := connect("died", get_node(Utils.MAIN_PATH), "_on_Player_died")


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
	var input_velocity := velocity.normalized()
	if player_state == PlayerState.DEFAULT and dashes > 0 and input_velocity.length() > 0:
		_set_player_state(PlayerState.DASHING)
		dash_velocity = input_velocity *  DASH_SPEED


func _set_player_state(new_state: int) -> void:
	
	match new_state:
		PlayerState.DEFAULT:
			player_sprite.set_modulate(DEFAULT_MODULATE)
		PlayerState.DASHING:
			dashes = dashes - 1
			emit_signal("dashes_changed", dashes)
			dash_particles.emitting = true
			dash_sound_player.play()		
			dash_timer.start(DASH_DURATION)
			if dash_cooldown_timer.is_stopped():
				dash_cooldown_timer.start(DASH_COOLDOWN_DURATION)
		PlayerState.HITSTUNNED:
			CanvasAnimationPlayer.screen_shake()
			player_hit_sound_player.play()
			player_sprite.hit_stun()
			player_sprite.set_modulate(HIT_STUNNED_MODULATE)
		PlayerState.INVULNERABLE:
			invulnerability_timer.start(INVULNERABILITY_DURATION)
			player_sprite.set_modulate(INVULNERABILITY_MODULATE)
	
	player_state = new_state


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


func _handle_collisions() -> void:
	for i in get_slide_count():
		var collision := get_slide_collision(i) as KinematicCollision2D
		if collision:
			var enemy := collision.collider as Enemy
			var obstacle := collision.collider as Obstacle
			if enemy or obstacle:
				_handle_hit(collision)


func _handle_hit(collision: KinematicCollision2D) -> void:
	if player_state != PlayerState.HITSTUNNED and player_state != PlayerState.INVULNERABLE:
		health = health - 1
		emit_signal("health_changed", health)
		
		if health <= 0:
			_die()
		else:
			_set_player_state(PlayerState.HITSTUNNED)
			
			hit_stun_velocity = collision.normal.normalized() * HIT_STUN_SPEED
			dash_timer.stop()
			hit_stun_timer.start(HIT_STUN_DURATION)


func _die() -> void:
	player_sprite.visible = false
	emit_signal("died")


func _update_zoom() -> void:
	camera.set_zoom(Vector2(camera_zoom, camera_zoom))


func _limit_zoom(z: float) -> float:
	if z > MAX_ZOOM:
		z = MAX_ZOOM
	if z < MIN_ZOOM:
		z = MIN_ZOOM
	return z


func _on_DashTimer_timeout() -> void:
	_set_player_state(PlayerState.DEFAULT)


func _on_DashCooldownTimer_timeout() -> void:
	dashes = dashes + 1
	emit_signal("dashes_changed", dashes)
	if dashes < MAX_DASHES:
		dash_cooldown_timer.start(DASH_COOLDOWN_DURATION)


func get_blade_node() -> Blade:
	return blade


func get_max_health() -> int:
	return MAX_HEALTH


func get_max_dashes() -> int:
	return MAX_DASHES


func _on_HitStunTimer_timeout() -> void:
	_set_player_state(PlayerState.INVULNERABLE)


func _on_InvulnerabilityTimer_timeout() -> void:
	_set_player_state(PlayerState.DEFAULT)
