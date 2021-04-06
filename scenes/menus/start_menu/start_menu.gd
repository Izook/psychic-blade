extends MarginContainer

class_name StartMenu

const LEVELS_MAP = {
	"The Slimes" : "three_slimes",
	"Playground" : "playground",
	"Slime Spawners": "slime_spawners",
	"Tutorial": "tutorial"
}

onready var version_label := $Version as Label

onready var start_button := $TitleContainer/VBoxContainer/VBoxContainer/StartButton as Button
onready var first_level_button := $LevelsContainer/Panel/MarginContainer/VBoxContainer/CenterContainer2/VBoxContainer/SlimesLevel as Button
onready var exit_controls_button := $ControlsContainer/Panel/MarginContainer/ExitControlsButton as TextureButton

onready var title_container := $TitleContainer as MarginContainer
onready var controls_container := $ControlsContainer as MarginContainer
onready var levels_container := $LevelsContainer as MarginContainer

onready var music_player := $Audio/MusicPlayer as AudioStreamPlayer
onready var select_sound_player := $Audio/SelectSoundPlayer as AudioStreamPlayer
onready var confirm_sound_player := $Audio/ConfirmSoundPlayer as AudioStreamPlayer
onready var cancel_sound_player := $Audio/CancelSoundPlayer as AudioStreamPlayer
onready var quit_sound_player := $Audio/QuitSoundPlayer as AudioStreamPlayer

onready var main := preload("res://scenes/main/main.tscn").instance() as Main

var menu_open := false

var grabbed_focus = false


func _ready() -> void:
	get_tree().get_root().set_disable_input(false)
	get_tree().paused = false
	AudioUtilities.set_distort_music(false)
	_load_version()


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down")  or event.is_action_pressed("ui_left")  or event.is_action_pressed("ui_right"):
		if not grabbed_focus:
			start_button.grab_focus()
			grabbed_focus = true
	
	if event.is_action_pressed('ui_cancel'):
		if menu_open:
			_exit_menu()


func _exit_menu() -> void:
	menu_open = false
	title_container.visible = true
	levels_container.visible = false
	controls_container.visible = false
	cancel_sound_player.play()
	select_sound_player.set_volume_db(-80.0)
	start_button.grab_focus()
	yield(cancel_sound_player, "finished")
	select_sound_player.set_volume_db(0.0)


func _load_version() -> void:
	var version_file := File.new()
	var _error := version_file.open(Utils.VERSION_PATH, File.READ)
	var version_number := version_file.get_as_text()
	version_label.set_text(version_number)


func _on_ExitControlsButton_pressed() -> void:
	_exit_menu()


func _on_ExitLevelsButton_pressed() -> void:
	_exit_menu()


func _on_LevelButton_pressed(level: String) -> void:
	get_tree().get_root().set_disable_input(true)
	var level_file := LEVELS_MAP[level] as String
	var level_path := Utils.LEVELS_DIR_PATH + ("%s/%s.tscn" % [level_file, level_file]) as String
	main.load_level(level_path)
	confirm_sound_player.play()
	yield(confirm_sound_player, "finished")
	get_tree().get_root().add_child(main)
	get_tree().set_current_scene(main)
	queue_free()


func _on_ControlsButton_pressed() -> void:
	menu_open = true
	title_container.visible = false
	controls_container.visible = true
	exit_controls_button.grab_focus()
	confirm_sound_player.play()


func _on_StartButton_pressed() -> void:
	menu_open = true
	title_container.visible = false
	levels_container.visible = true
	first_level_button.grab_focus()
	confirm_sound_player.play()


func _on_QuitPlayingButton_pressed() -> void:
	quit_sound_player.play()
	yield(quit_sound_player, "finished")
	get_tree().quit()


func _on_MusicPlayer_finished() -> void:
	music_player.play()


func _on_Button_focus_entered() -> void:
	select_sound_player.play()
