extends KinematicBody2D

export (int) var speed = 50

var velocity = Vector2()

var players

var is_alive = true


func _ready():
	players = get_tree().get_nodes_in_group("players")


func _find_player():
	if players.size() > 0:
		var player_position = players[0].position
		velocity = position.direction_to(player_position)  * speed


func _rotate_enemy():
	set_global_rotation(velocity.angle() + PI / 2)


func _physics_process(delta):
	if is_alive:
		_find_player()
		_rotate_enemy()
		
		var collision_info = move_and_slide(velocity)
		
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision.collider.name == "Blade":
				is_alive = false
				$CollisionShape2D.set_disabled(true)
				$Sprite.visible = false
				$Particles2D.set_emitting(true)
			if collision.collider.name == "Player":
				players[0].queue_free()

