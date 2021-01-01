extends KinematicBody2D

class_name Enemy

export (int) var speed := 6000

var velocity := Vector2()
var is_alive := true

onready var player := get_tree().get_nodes_in_group("players")[0] as Node2D
onready var collision_shape := $CollisionShape2D as CollisionShape2D
onready var sprite := $Sprite as Sprite
onready var particles := $Particles2D as Particles2D


func _find_player(delta: float) -> void:
	var player_position := player.global_position as Vector2
	velocity = global_position.direction_to(player_position)  * speed * delta


func _rotate_enemy():
	set_global_rotation(velocity.angle() + PI / 2)


func _physics_process(delta: float):
	if is_alive:
		_find_player(delta)
		_rotate_enemy()
		
		var _collision_vector := move_and_slide(velocity)
		
		for i in get_slide_count():
			var collision := get_slide_collision(i) as KinematicCollision2D
			if collision.collider.name == "Blade":
				is_alive = false
				collision_shape.set_disabled(true)
				sprite.visible = false
				particles.set_emitting(true)
			if collision.collider.name == "Player":
				player.queue_free()
