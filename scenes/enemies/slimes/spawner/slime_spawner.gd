extends Spawner

class_name SlimeSpawner

onready var particles := $Particles2D as Particles2D
onready var spawn_sound_player := $SlimeSpawnSoundPlayer as AudioStreamPlayer2D


func _ready() -> void:
	enemy_scene = preload("res://scenes/enemies/slimes/slime/slime.tscn")


func set_active(new_active: bool) -> void:
	.set_active(new_active)
	particles.emitting = new_active


func _on_SpawnTimer_timeout() -> void:
	if active:
		spawn_sound_player.play()
	
	._on_SpawnTimer_timeout()
