extends AnimatedSprite

class_name PlayerSprite

enum Directions {
	UP = 0,
	RIGHT = 1,
	DOWN = 2,
	LEFT = 3
}

var is_moving := false
var direction_facing = Directions.DOWN


func move_towards(velocity: Vector2):
	if velocity.y > 0:
		move_down()
	elif velocity.y < 0:
		move_up()
	elif velocity.x > 0:
		move_right()
	elif velocity.x < 0:
		move_left()
	elif velocity.length() == 0:
		stop_moving()


func stop_moving():
	is_moving = false
	match direction_facing:
		Directions.UP:
			set_flip_h(false)
			play("up_idle")
		Directions.RIGHT:
			set_flip_h(true)
			play("side_idle")
		Directions.DOWN:
			set_flip_h(false)
			play("down_idle")
		Directions.LEFT:
			set_flip_h(false)
			play("side_idle")


func hitstun():
	is_moving = false
	play("hitstun")


func move_up():
	direction_facing = Directions.UP
	set_flip_h(false)
	play("up_walk")


func move_right():
	direction_facing = Directions.RIGHT
	set_flip_h(true)
	play("side_walk")


func move_left():
	direction_facing = Directions.LEFT
	set_flip_h(false)
	play("side_walk")


func move_down():
	direction_facing = Directions.DOWN
	set_flip_h(false)
	play("down_walk")
