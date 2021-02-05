extends Enemy

class_name Slime

enum SlimeState {WANDERING, ATTACKING, DEAD}

const MAX_SPEED := 75
const CAST_LENGTH := 150

onready var player := get_node(Utils.PLAYER_PATH) as Player
onready var sprite := $Sprite as AnimatedSprite
onready var hitbox := $CollisionPolygon as CollisionShape2D
onready var animation_player := $AnimationPlayer as AnimationPlayer
onready var raycast := $RayCast2D as RayCast2D
onready var death_timer := $DeathTimer as Timer

onready var wander_direction := Vector2(rand_range(-1, 1), rand_range(-1, 1))
onready var idle_animation_length := animation_player.get_animation("idle").length

var speed_time := 0.0 
var slime_state = SlimeState.WANDERING


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


func die() -> void:
	slime_state = SlimeState.DEAD
	hitbox.set_disabled(true)
	animation_player.play("death")
	
	remove_from_group("enemies")
	hitbox.set_disabled(true)
	death_timer.start()


func _move_slime(velocity: Vector2, delta: float) -> void:
	var collision_info := move_and_collide(velocity * delta)
	
	animation_player.play("slide")
	sprite.set_flip_h(false)
	if velocity.x > 0:
		sprite.set_flip_h(true)


func _get_slime_speed(delta: float) -> float:
	speed_time += delta
	speed_time = fmod(speed_time, idle_animation_length)
	return abs(sin((5 * PI / 2) * speed_time)) * MAX_SPEED


func _renew_wander_direction() -> void:
	wander_direction = Vector2(rand_range(-1, 1), rand_range(-1, 1))
	raycast.set_cast_to(wander_direction * CAST_LENGTH)
	
	var attempts := 1
	while raycast.is_colliding() && attempts <= 5:
		attempts += 1
		wander_direction = Vector2(rand_range(-1, 1), rand_range(-1, 1))
		raycast.set_cast_to(wander_direction * CAST_LENGTH)
		raycast.force_raycast_update()
	
	if attempts > 5:
		wander_direction = Vector2(0,0)
		animation_player.play("idle")


func _on_WanderingTimer_timeout() -> void:
	if slime_state == SlimeState.WANDERING:
		_renew_wander_direction()


func _on_DetectionArea_body_entered(body: PhysicsBody2D) -> void:
	if slime_state != SlimeState.DEAD:
		var player := body as Player
		if player:
			slime_state = SlimeState.ATTACKING



func _on_DeathTimer_timeout() -> void:
	queue_free()
