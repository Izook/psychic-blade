extends Node

class_name Main

onready var pause_menu := $UILayer/PauseMenu as MarginContainer
onready var gameover_menu := $UILayer/GameOverMenu as MarginContainer

var paused := false


func _ready() -> void:
	paused = false


func load_level(level_path: String) -> void:
	var level_scene := load(level_path) as PackedScene
	var level = level_scene.instance() as Node2D
	level.set_name("Level")
	$GameLayer.add_child(level)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_pause"):
		if not paused:
			paused = true
		else:
			paused = false
		get_tree().paused = paused
		pause_menu.visible = paused


func _on_Player_player_died() -> void:
	get_tree().paused = true
	gameover_menu.visible = true
