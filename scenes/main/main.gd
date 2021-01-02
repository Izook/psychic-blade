extends Node

class_name Main

var paused = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_pause"):
		if not paused:
			paused = true
		else:
			paused = false
		get_tree().paused = paused
		$UILayer/PauseMenu.visible = paused
