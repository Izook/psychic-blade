extends Button

class_name CustomButton


func _ready() -> void:
	var _enter_conn_error := connect("mouse_entered", self, "_on_self_mouse_entered")
	var _exit_conn_error := connect("mouse_exited", self, "_on_self_mouse_exited")


func _on_self_mouse_entered() -> void:
	grab_focus()


func _on_self_mouse_exited() -> void:
	release_focus()
