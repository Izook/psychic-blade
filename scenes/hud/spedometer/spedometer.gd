extends Node2D

onready var needle_node := $Dial/Needle as Sprite

var current_speed := 0.0
var max_speed := 100.0


func set_max_speed(new_max_speed: float) -> void:
	max_speed = new_max_speed


func set_current_speed(new_speed: float) -> void:
	current_speed = new_speed
	_update_needle()


func _update_needle() -> void:
	var new_angle := (current_speed / max_speed) * PI - (PI / 2) 
	needle_node.set_rotation(new_angle)
