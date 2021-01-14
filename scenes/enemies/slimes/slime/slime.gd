extends KinematicBody2D

class_name Slime

enum SlimeState {WANDERING, ATTACKING, DEAD}

const MAX_SPEED := 100
const CAST_LENGTH := 500
const IDLE_ANIMATION_FINISH := 1.5

onready var player := get_node("root/Main/GameLayer/Player") as Player
onready var collision_shape := $CollisionPolygon2D as CollisionPolygon2D
onready var sprite := $Sprite as Sprite
onready var animation_player := $AnimationPlayer as AnimationPlayer
onready var raycast := $RayCast2D as RayCast2D

onready var wander_direction := Vector2(rand_range(-1, 1), rand_range(-1, 1))


var slime_state = SlimeState.WANDERING
var speed_time := 0.0

func _physics_process(delta: float) -> void:
	
	match slime_state:
		SlimeState.WANDERING:
			wander(delta)
		SlimeState.ATTACKING:
			attack(delta)
		SlimeState.DEAD:
			die()


func wander(delta: float) -> void:
	var velocity = wander_direction * get_slime_speed(delta)
	var _collision_vector := move_and_slide(velocity)


func attack(delta: float) -> void:
	pass


func die() -> void:
	pass


func get_slime_speed(delta: float) -> float:
	speed_time += delta
	speed_time = fmod(speed_time, IDLE_ANIMATION_FINISH)
	return sin((2 * PI / 3) * speed_time) * MAX_SPEED


func renew_wander_direction() -> void:
	wander_direction = Vector2(rand_range(-1, 1), rand_range(-1, 1))
	raycast.set_cast_to(wander_direction * CAST_LENGTH)
	
	while raycast.get_collider() != null:
		wander_direction = Vector2(rand_range(-1, 1), rand_range(-1, 1))
		raycast.set_cast_to(wander_direction * CAST_LENGTH)


func _on_WanderingTimer_timeout() -> void:
	renew_wander_direction()
