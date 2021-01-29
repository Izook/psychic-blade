extends MarginContainer

class_name PauseMenu

signal unpaused

onready var main_menu_button := $PanelContainer/MarginContainer/VBoxContainer/MainMenuButton as Button


func _ready() -> void:
	var _menu_conn_error = connect("unpaused", get_node(Utils.MAIN_PATH), "_on_PauseMenu_unpaused")


func focus() -> void:
	main_menu_button.grab_focus()


func _on_MainMenuButton_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.is_pressed() and mouse_event.button_index == 1:
			var _error = get_tree().change_scene(Utils.START_SCENE_PATH)


func _on_MainMenuButton_pressed() -> void:
	var _error = get_tree().change_scene(Utils.START_SCENE_PATH)


func _on_UnPauseButton_pressed() -> void:
	emit_signal("unpaused")

	
