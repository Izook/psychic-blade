extends MarginContainer

class_name GameOverMenu

onready var main_menu_button := $PanelContainer/MarginContainer/VBoxContainer/MainMenuButton as Button

onready var select_sound_player := $Audio/SelectSoundPlayer as AudioStreamPlayer
onready var confirm_sound_player := $Audio/ConfirmSoundPlayer as AudioStreamPlayer

var grabbed_focus := true


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down")  or event.is_action_pressed("ui_left")  or event.is_action_pressed("ui_right"):
		if not grabbed_focus:
			main_menu_button.grab_focus()
			grabbed_focus = true


func set_active(active: bool) -> void:
	AudioUtilities.set_distort_music(active)
	visible = active
	grabbed_focus = false


func _on_MainMenuButton_pressed() -> void:
	get_tree().get_root().set_disable_input(true)
	confirm_sound_player.play()
	yield(confirm_sound_player, "finished")
	var _error = get_tree().change_scene(Utils.START_SCENE_PATH)


func _on_Button_focus_entered() -> void:
	select_sound_player.play()
