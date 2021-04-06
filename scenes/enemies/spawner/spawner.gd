extends Node2D

class_name Spawner

signal active_changed(new_active)
signal all_enemies_slayed

var enemy_scene : PackedScene

var active := false

var spawning_limited_enemies := false
var enemies_to_spawn : int
var enemies_spawned := 0
var enemies_slayed := 0


func set_active(new_active: bool) -> void:
	active = new_active
	emit_signal("active_changed", new_active)


func spawn_limited_enemies(count: int) -> void:
	spawning_limited_enemies = true
	enemies_to_spawn = count


func _on_SpawnTimer_timeout() -> void:
	if active: 
		var enemies := get_tree().get_nodes_in_group("enemies")
		var max_global_enemies_reached := enemies.size() > 100 
		
		if not max_global_enemies_reached:
			var new_enemy := enemy_scene.instance() as Node2D
			new_enemy.position = position
			new_enemy.connect("died", self, "_on_SpawnedEnemy_died")
			get_parent().add_child(new_enemy)
			enemies_spawned += 1
		
		if spawning_limited_enemies and enemies_spawned >= enemies_to_spawn:
			set_active(false)


func _on_SpawnedEnemy_died() -> void:
	enemies_slayed += 1
	
	if spawning_limited_enemies and enemies_slayed >= enemies_to_spawn:
		emit_signal("all_enemies_slayed")
