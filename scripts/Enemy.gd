extends KinematicBody2D

export (int) var speed = 50

var velocity = Vector2()

var players


func _enter_tree():
	players = get_tree().get_nodes_in_group("players")


func _find_player():
	var player_position = players[0].position
	velocity = position.direction_to(player_position)  * speed


func _rotate_enemy():
	set_global_rotation(velocity.angle() + PI / 2)


func _physics_process(delta):
	_find_player()
	_rotate_enemy()
	
	var collision_info = move_and_slide(velocity)
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "Blade":
			queue_free()
		if collision.collider.name == "Player":
			players[0].queue_free()

