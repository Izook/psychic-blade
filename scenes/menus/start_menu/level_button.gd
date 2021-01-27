extends Button

class_name LevelButton

signal level_pressed(level_name)


func _ready() -> void:
	var _self_conn_error = connect("pressed", self, "_on_self_pressed")
	var _menu_conn_error = connect("level_pressed", get_node(Utils.START_PATH), "_on_LevelButton_pressed")


func _on_self_pressed() -> void:
	emit_signal("level_pressed", text)
