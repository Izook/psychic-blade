extends Node2D

class_name DashIcon

onready var full_icon_sprite := $FullIcon as Sprite
onready var empty_icon_sprite := $EmptyIcon as Sprite
onready var emptied_particles := $EmptiedParticles as Particles2D
onready var refilled_particles := $RefilledParticles as Particles2D

var is_empty := false


func empty() -> void:
	if not is_empty:
		is_empty = true
		emptied_particles.emitting = true
		empty_icon_sprite.visible = true
		full_icon_sprite.visible = false


func refill() -> void:
	if is_empty:
		is_empty = false
		refilled_particles.emitting = true
		empty_icon_sprite.visible = false
		full_icon_sprite.visible = true

