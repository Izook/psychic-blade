extends MarginContainer

class_name GameOverMenu

onready var main_menu_button := $PanelContainer/MarginContainer/VBoxContainer/MainMenuButton as Button


func focus() -> void:
	main_menu_button.grab_focus()


func _on_MainMenuButton_pressed() -> void:
	var _error = get_tree().change_scene(Utils.START_SCENE_PATH)
