extends Label

class_name LevelButton

signal clicked(level_name)


func _ready() -> void:
	var _self_conn_error = connect("gui_input", self, "_on_self_gui_input")
	var _menu_conn_error = connect("clicked", get_node(Utils.START_PATH), "_on_LevelButton_clicked")


func _on_self_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.is_pressed() and mouse_event.button_index == 1:
			emit_signal("clicked", text)
