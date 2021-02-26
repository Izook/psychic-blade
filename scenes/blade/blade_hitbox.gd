extends KinematicBody2D

class_name BladeHitbox

onready var blade_node := get_parent() as Blade

func get_blade() -> Blade: 
	return blade_node
