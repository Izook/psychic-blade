# Spawner 

extends Node2D

var enemy_scene : PackedScene
var active := true

class_name Spawner


func _on_SpawnTimer_timeout() -> void:
	if active:
		var new_enemy := enemy_scene.instance() as Node2D
		new_enemy.position = position
		get_parent().add_child(new_enemy)


func _process(_delta: float) -> void:
	var enemies := get_tree().get_nodes_in_group("enemies")
	
	if enemies.size() > 100:
		active = false
	else:
		active = true
