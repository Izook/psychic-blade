extends KinematicBody2D

export (int) var speed = 50

var velocity = Vector2()

var players

func _enter_tree():
	players = get_tree().get_nodes_in_group("players")

func find_player():
	var player_position = players[0].position
	velocity = position.direction_to(player_position)  * speed

func _physics_process(delta):
	find_player()
	move_and_slide(velocity)
