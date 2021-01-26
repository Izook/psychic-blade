# Spawner 

extends Node2D

var enemy_scene : PackedScene

class_name Spawner

func _on_SpawnTimer_timeout() -> void:
	var new_enemy := enemy_scene.instance() as Node2D
	new_enemy.position = position
	get_parent().add_child(new_enemy)
