extends Node2D

onready var impact_particles := $Particles2D as Particles2D


func _ready() -> void:
	impact_particles.set_emitting(true)


func _on_DeathTimer_timeout() -> void:
	queue_free()
