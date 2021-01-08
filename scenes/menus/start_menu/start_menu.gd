extends MarginContainer

class_name StartMenu

onready var version_label := $Version as Label
onready var controls_container := $ControlsContainer as MarginContainer

func _ready() -> void:
	get_tree().paused = false
	_load_version()


func _load_version() -> void:
	var version_file = File.new()
	version_file.open("res://VERSION", File.READ)
	var version_number = version_file.get_as_text()
	version_label.set_text(version_number)


func _on_StartButton_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.is_pressed() and mouse_event.button_index == 1:
			var _error = get_tree().change_scene("res://scenes/main/main.tscn")


func _on_ControlsButton_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.is_pressed() and mouse_event.button_index == 1:
			controls_container.visible = true


func _on_ExitControlsButton_pressed() -> void:
	controls_container.visible = false
