extends MarginContainer

class_name StartMenu

const LEVELS_MAP = {
	"The Slimes" : "three_slimes",
	"Playground" : "playground",
	"Slime Spawners": "slime_spawners"
}

onready var version_label := $Version as Label
onready var controls_container := $ControlsContainer as MarginContainer
onready var levels_container := $LevelsContainer as MarginContainer

onready var main := preload("res://scenes/main/main.tscn").instance() as Main


func _ready() -> void:
	get_tree().paused = false
	_load_version()


func _load_version() -> void:
	var version_file = File.new()
	version_file.open(Utils.VERSION_PATH, File.READ)
	var version_number = version_file.get_as_text()
	version_label.set_text(version_number)


func _on_StartButton_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.is_pressed() and mouse_event.button_index == 1:
			levels_container.visible = true


func _on_ControlsButton_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.is_pressed() and mouse_event.button_index == 1:
			controls_container.visible = true


func _on_ExitControlsButton_pressed() -> void:
	controls_container.visible = false


func _on_ExitLevelsButton_pressed() -> void:
	levels_container.visible = false


func _on_LevelButton_clicked(level: String) -> void:
	var level_file = LEVELS_MAP[level] as String
	var level_path := Utils.LEVELS_DIR_PATH + ("%s/%s.tscn" % [level_file, level_file]) as String
	main.load_level(level_path)
	get_tree().get_root().add_child(main)
	get_tree().set_current_scene(main)
	queue_free()
