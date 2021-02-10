extends MarginContainer

class_name PauseMenu

signal unpaused

onready var main_menu_button := $PanelContainer/MarginContainer/VBoxContainer/MainMenuButton as Button

onready var pause_sound_player := $Audio/PauseSoundPlayer as AudioStreamPlayer
onready var resume_sound_player := $Audio/ResumeSoundPlayer as AudioStreamPlayer
onready var select_sound_player := $Audio/SelectSoundPlayer as AudioStreamPlayer
onready var confirm_sound_player := $Audio/ConfirmSoundPlayer as AudioStreamPlayer

var focus_grabbed := false


func _ready() -> void:
	var _menu_conn_error = connect("unpaused", get_node(Utils.MAIN_PATH), "_on_PauseMenu_unpaused")


func _input(event: InputEvent) -> void:

	if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down")  or event.is_action_pressed("ui_left")  or event.is_action_pressed("ui_right"):
		print("UI ACTION DETECTED BY PAUSE")
		if not focus_grabbed:
			focus_grabbed = true
			main_menu_button.grab_focus()


func set_active(active: bool) -> void:
	visible = active
	if active:
		focus_grabbed = false
		pause_sound_player.play()
	else:
		resume_sound_player.play()


func _on_MainMenuButton_pressed() -> void:
	confirm_sound_player.play()
	get_tree().get_root().set_disable_input(true)
	var _error = get_tree().change_scene(Utils.START_SCENE_PATH)


func _on_UnPauseButton_pressed() -> void:
	resume_sound_player.play()
	emit_signal("unpaused")


func _on_Button_focus_entered() -> void:
	select_sound_player.play()
