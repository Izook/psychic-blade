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
			play("idle_up")
		Directions.RIGHT:
			set_flip_h(false)
			play("idle_right")
		Directions.DOWN:
			set_flip_h(false)
			play("idle_down")
		Directions.LEFT:
			set_flip_h(true)
			play("idle_right")


func move_up():
	direction_facing = Directions.UP
	set_flip_h(false)
	if not is_moving:
		play("move_up_start")
		yield(self, "animation_finished")
		if get_animation() == "move_up_start":
			is_moving = true
			play("move_up")
	else:
		play("move_up")


func move_right():
	direction_facing = Directions.RIGHT
	set_flip_h(false)
	if not is_moving:
		play("move_right_start")
		yield(self, "animation_finished")
		if get_animation() == "move_right_start":
			is_moving = true
			play("move_right")
	else:
		play("move_right")


func move_left():
	direction_facing = Directions.LEFT
	set_flip_h(true)
	if not is_moving:
		play("move_right_start")
		yield(self, "animation_finished")
		if get_animation() == "move_right_start":
			is_moving = true
			play("move_right")
	else:
		play("move_right")


func move_down():
	direction_facing = Directions.DOWN
	set_flip_h(true)
	if not is_moving:
		play("move_down_start")
		yield(self, "animation_finished")
		if get_animation() == "move_down_start":
			is_moving = true
			play("move_down")
	else:
		play("move_down")
