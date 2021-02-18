extends KinematicBody2D

class_name Enemy

onready var hitbox := $HitBox as Area2D

func _ready() -> void:
	add_to_group("enemies")
	var _conn_error := hitbox.connect("body_entered", self, "_on_HitBox_body_entered")
	


func _on_HitBox_body_entered(body: Node) -> void:
	var blade_hitbox := body as BladeHitbox
	if blade_hitbox:
		var blade := blade_hitbox.get_blade() 
		blade.impact_entity(self)
		hit()


func hit() -> void:
	die()


func die() -> void: 
	queue_free()
