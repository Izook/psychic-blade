extends MarginContainer

class_name PauseMenu

signal unpaused

onready var main_menu_button := $PanelContainer/MarginContainer/VBoxContainer/CenterContainer2/MainMenuButton as Button

onready var pause_sound_player := $Audio/PauseSoundPlayer as AudioStreamPlayer
onready var resume_sound_player := $Audio/ResumeSoundPlayer as AudioStreamPlayer
onready var select_sound_player := $Audio/SelectSoundPlayer as AudioStreamPlayer
onready var confirm_sound_player := $Audio/ConfirmSoundPlayer as AudioStreamPlayer

var active := false

func _ready() -> void:
	var _menu_conn_error = connect("unpaused", get_node(Utils.MAIN_PATH), "_on_PauseMenu_unpaused")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down")  or event.is_action_pressed("ui_left")  or event.is_action_pressed("ui_right"):
		if active and not get_focus_owner():
			main_menu_button.grab_focus()


func set_active(new_active: bool) -> void:
	active = new_active
	AudioUtilities.set_distort_music(active)
	visible = active
	if active:
		pause_sound_player.play()
	else:
		resume_sound_player.play()


func _on_MainMenuButton_pressed() -> void:
	get_tree().get_root().set_disable_input(true)
	confirm_sound_player.play()
	yield(confirm_sound_player, "finished")
	var _error = get_tree().change_scene(Utils.START_SCENE_PATH)


func _on_UnPauseButton_pressed() -> void:
	emit_signal("unpaused")


func _on_Button_focus_entered() -> void:
	select_sound_player.play()
