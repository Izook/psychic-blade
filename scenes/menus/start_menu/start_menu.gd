extends MarginContainer

class_name StartMenu

const LEVELS_MAP = {
	"The Slimes" : "three_slimes",
	"Playground" : "playground",
	"Slime Spawners": "slime_spawners"
}

onready var version_label := $Version as Label

onready var start_button := $TitleContainer/VBoxContainer/CenterContainer2/VBoxContainer/StartButton as Button
onready var controls_button := $TitleContainer/VBoxContainer/CenterContainer2/VBoxContainer/ControlsButton as Button
onready var first_level_button := $LevelsContainer/Panel/MarginContainer/VBoxContainer/CenterContainer2/VBoxContainer/SlimesLevel as Button
onready var exit_controls_button := $ControlsContainer/Panel/MarginContainer/ExitControlsButton as TextureButton

onready var controls_container := $ControlsContainer as MarginContainer
onready var levels_container := $LevelsContainer as MarginContainer

onready var main := preload("res://scenes/main/main.tscn").instance() as Main

var menu_open := false


func _ready() -> void:
	start_button.grab_focus()
	get_tree().paused = false
	_load_version()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed('ui_cancel'):
		if menu_open:
			menu_open = false
			levels_container.visible = false
			controls_container.visible = false
			start_button.grab_focus()


func _load_version() -> void:
	var version_file := File.new()
	var _error := version_file.open(Utils.VERSION_PATH, File.READ)
	var version_number := version_file.get_as_text()
	version_label.set_text(version_number)


func _on_ExitControlsButton_pressed() -> void:
	menu_open = false
	controls_container.visible = false
	controls_button.grab_focus()


func _on_ExitLevelsButton_pressed() -> void:
	menu_open = false
	levels_container.visible = false
	start_button.grab_focus()


func _on_LevelButton_pressed(level: String) -> void:
	var level_file := LEVELS_MAP[level] as String
	var level_path := Utils.LEVELS_DIR_PATH + ("%s/%s.tscn" % [level_file, level_file]) as String
	main.load_level(level_path)
	get_tree().get_root().add_child(main)
	get_tree().set_current_scene(main)
	queue_free()


func _on_ControlsButton_pressed() -> void:
	menu_open = true
	controls_container.visible = true
	exit_controls_button.grab_focus()


func _on_StartButton_pressed() -> void:
	menu_open = true
	levels_container.visible = true
	first_level_button.grab_focus()
