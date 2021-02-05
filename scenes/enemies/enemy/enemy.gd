extends KinematicBody2D

class_name Enemy


func _ready() -> void:
	add_to_group("enemies")


func die() -> void: 
	queue_free()
