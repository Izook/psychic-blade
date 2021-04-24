extends MarginContainer

class_name LevelCompleteMenu

onready var main_menu_button := $PanelContainer/MarginContainer/VBoxContainer/MainMenuButton as Button
onready var run_time_label := $PanelContainer/MarginContainer/VBoxContainer/Scores/VBoxContainer/RunTime as Label
onready var enemies_killed_label := $PanelContainer/MarginContainer/VBoxContainer/Scores/VBoxContainer/EnemiesKilled as Label
onready var highest_combo_label := $PanelContainer/MarginContainer/VBoxContainer/Scores/VBoxContainer/HighestCombo as Label

onready var select_sound_player := $Audio/SelectSoundPlayer as AudioStreamPlayer
onready var confirm_sound_player := $Audio/ConfirmSoundPlayer as AudioStreamPlayer
onready var level_complete_sound_player := $Audio/LevelCompleteSoundPlayer as AudioStreamPlayer

var active := false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down")  or event.is_action_pressed("ui_left")  or event.is_action_pressed("ui_right"):
		if active and not get_focus_owner():
			main_menu_button.grab_focus()


func set_active(new_active: bool) -> void:
	active = new_active
	AudioUtilities.set_music_mute(active)
	visible = active
	
	var hud_node := get_node(Utils.HUD_PATH) as Hud
	run_time_label.set_text("Completion Time: " + str(hud_node.get_elapsed_time_string()))
	enemies_killed_label.set_text("Enemies Killed: %02d" % hud_node.get_kill_count())
	highest_combo_label.set_text("Highest Combo: %02d" % hud_node.get_highest_combo())
	
	if active:
		level_complete_sound_player.play()


func _on_MainMenuButton_pressed() -> void:
	get_tree().get_root().set_disable_input(true)
	confirm_sound_player.play()
	yield(confirm_sound_player, "finished")
	AudioUtilities.set_music_mute(false)
	var _error = get_tree().change_scene(Utils.START_SCENE_PATH)


func _on_Button_focus_entered() -> void:
	select_sound_player.play()
