extends Node2D

class_name DashIcon

onready var icon_sprite := $Sprite as Sprite
onready var emptied_particles := $EmptiedParticles as Particles2D
onready var refilled_particles := $RefilledParticles as Particles2D

onready var dash_empty_sprite := load(get_script().resource_path + "/../dash_empty.png")
onready var dash_full_sprite := load(get_script().resource_path + "/../dash_full.png")

var is_empty := false

func empty() -> void:
	if not is_empty:
		is_empty = true
		emptied_particles.emitting = true
		icon_sprite.set_texture(dash_empty_sprite)


func refill() -> void:
	if is_empty:
		is_empty = false
		refilled_particles.emitting = true
		icon_sprite.set_texture(dash_full_sprite)

