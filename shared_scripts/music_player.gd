extends AudioStreamPlayer

class_name MusicPlayer


func _ready() -> void:
	var _self_conn_error = connect("finished", self, "_on_self_finished")


func _on_self_finished() -> void:
	play()
