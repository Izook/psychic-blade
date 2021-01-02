extends MarginContainer

class_name StartMenu


func _on_StartButton_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.is_pressed() and mouse_event.button_index == 1:
			get_tree().change_scene("res://scenes/main/main.tscn")


func _on_ControlsButton_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.is_pressed() and mouse_event.button_index == 1:
			$ControlsContainer.visible = true


func _on_ExitControlsButton_pressed() -> void:
	$ControlsContainer.visible = false
