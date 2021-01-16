extends Enemy

class_name Slime

enum SlimeState {WANDERING, ATTACKING, DEAD}

const MAX_SPEED := 100
const CAST_LENGTH := 500
const IDLE_ANIMATION_FINISH := 1.5

onready var player := get_node("/root/Main/GameLayer/Player") as Player
onready var hitbox := $CollisionPolygon as CollisionPolygon2D
onready var animation_player := $AnimationPlayer as AnimationPlayer
onready var raycast := $RayCast2D as RayCast2D

onready var wander_direction := Vector2(rand_range(-1, 1), rand_range(-1, 1))

var slime_state = SlimeState.WANDERING
var speed_time := 0.0


func _physics_process(delta: float) -> void:
	
	match slime_state:
		SlimeState.WANDERING:
			_wander(delta)
		SlimeState.ATTACKING:
			_attack(delta)
		SlimeState.DEAD:
			pass


func _wander(delta: float) -> void:
	var velocity := wander_direction * _get_slime_speed(delta)
	_move_slime(velocity, delta)


func _attack(delta: float) -> void:
	var player_direction = global_position.direction_to(player.global_position)
	var velocity := (player_direction * _get_slime_speed(delta)) as Vector2
	_move_slime(velocity, delta)


func _die() -> void:
	slime_state = SlimeState.DEAD
	hitbox.set_disabled(true)
	animation_player.play("death")


func _move_slime(velocity: Vector2, delta: float) -> void:
	var collision_info := move_and_collide(velocity * delta)
	if collision_info:
		var blade := collision_info.collider as BladeHitbox
		if blade:
			die()


func _get_slime_speed(delta: float) -> float:
	speed_time += delta
	speed_time = fmod(speed_time, IDLE_ANIMATION_FINISH)
	return sin((2 * PI / 3) * speed_time) * MAX_SPEED


func _renew_wander_direction() -> void:
	wander_direction = Vector2(rand_range(-1, 1), rand_range(-1, 1))
	raycast.set_cast_to(wander_direction * CAST_LENGTH)
	
	while not raycast.is_colliding():
		wander_direction = Vector2(rand_range(-1, 1), rand_range(-1, 1))
		raycast.set_cast_to(wander_direction * CAST_LENGTH)
		raycast.force_raycast_update()


func _on_WanderingTimer_timeout() -> void:
	if slime_state == SlimeState.WANDERING:
		_renew_wander_direction()


func _on_DetectionArea_body_entered(body: PhysicsBody2D) -> void:
	if slime_state != SlimeState.DEAD:
		var player := body as Player
		if player:
			slime_state = SlimeState.ATTACKING

