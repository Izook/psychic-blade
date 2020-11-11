extends KinematicBody2D

const MIN_ZOOM := 0.75
const MAX_ZOOM := 2.0

export (int) var speed := 200
export (float) var zoom_speed := 0.005

onready var camera := $PlayerCamera as Camera2D

var velocity := Vector2()
var zoom_factor := 1.0

func _get_input() -> void:
	velocity = Vector2()
	if Input.is_action_pressed('move_right'):
		velocity.x += 1
	if Input.is_action_pressed('move_left'):
		velocity.x -= 1
	if Input.is_action_pressed('move_down'):
		velocity.y += 1
	if Input.is_action_pressed('move_up'):
		velocity.y -= 1
	if Input.is_action_pressed('zoom_out'):
		zoom_factor += zoom_speed
	if Input.is_action_pressed('zoom_in'):
		zoom_factor -= zoom_speed
	
	velocity = velocity.normalized() * speed
	zoom_factor = _limit_zoom(zoom_factor)


func _physics_process(_delta) -> void:
	_get_input()
	var _collision_info := move_and_slide(velocity)

	camera.set_zoom(Vector2(zoom_factor, zoom_factor))
	camera.make_current()


func _limit_zoom(z: float) -> float:
	if z > MAX_ZOOM:
		z = MAX_ZOOM
	if z < MIN_ZOOM:
		z = MIN_ZOOM
	print(z)
	return z
