extends Node2D

class_name BladeDash

onready var spedometer_needle := $SpedometerGuage/Needle as Sprite
onready var tachometer_needle := $TachometerGuage/Needle as Sprite

var current_speed := 0.0
var max_speed := 100.0

var current_angular_speed := 0.0
var max_angular_speed := 50.0


func set_max_speed(new_max_speed: float) -> void:
	max_speed = new_max_speed


func set_current_speed(new_speed: float) -> void:
	current_speed = new_speed
	_update_spedometer_needle()


func _update_spedometer_needle() -> void:
	var new_angle := ((current_speed / max_speed) * (3 * PI / 2)) - (3 * PI / 4) 
	spedometer_needle.set_rotation(new_angle)


func set_max_angular_speed(new_max_angular_speed: float) -> void:
	max_angular_speed = new_max_angular_speed


func set_current_angular_speed(new_angular_speed: float) -> void:
	current_angular_speed = new_angular_speed
	_update_tachometer_needle()


func _update_tachometer_needle() -> void:
	print(current_angular_speed)
	var new_angle := ((current_angular_speed / max_angular_speed) * (3 * PI / 2)) - (3 * PI / 4) 
	tachometer_needle.set_rotation(new_angle)
