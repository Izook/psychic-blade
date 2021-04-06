extends Spawner

class_name SlimeSpawner

onready var particles := $Particles2D as Particles2D


func _ready() -> void:
	enemy_scene = preload("res://scenes/enemies/slimes/slime/slime.tscn")


func set_active(new_active: bool) -> void:
	.set_active(new_active)
	particles.emitting = new_active
