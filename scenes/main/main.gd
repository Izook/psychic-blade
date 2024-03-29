extends Node

class_name Main

onready var pause_menu := $UILayer/PauseMenu as PauseMenu
onready var gameover_menu := $UILayer/GameOverMenu as GameOverMenu
onready var level_complete_menu := $UILayer/LevelCompleteMenu as LevelCompleteMenu

var paused := false
var level : Node2D


func _ready() -> void:
	CanvasAnimationPlayer.init()
	get_tree().get_root().set_disable_input(false)
	paused = false


func load_level(level_path: String) -> void:
	var level_scene := load(level_path) as PackedScene
	level = level_scene.instance() as Node2D
	level.set_name("Level")
	$GameLayer.add_child(level)


func get_active_level() -> Node2D:
	return level


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_pause"):
		paused = not paused
		get_tree().paused = paused
		pause_menu.set_active(paused)


func _on_Player_died() -> void:
	get_tree().paused = true
	gameover_menu.set_active(true)


func _on_Level_completed() -> void:
	get_tree().paused = true
	level_complete_menu.set_active(true)


func _on_PauseMenu_unpaused() -> void:
	paused = false
	get_tree().paused = false
	pause_menu.set_active(false)
