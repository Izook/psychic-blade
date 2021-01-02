extends MarginContainer

class_name GameOverMenu


func _on_MainMenuButton_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.is_pressed() and mouse_event.button_index == 1:
			var _error = get_tree().change_scene("res://scenes/menus/start_menu/start_menu.tscn")
