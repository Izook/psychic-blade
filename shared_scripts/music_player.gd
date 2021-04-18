# Music Player 
# Class attached to AudioStream players to automatically loop music.

extends AudioStreamPlayer

class_name MusicPlayer


var active := true


func _ready() -> void:
	var _self_conn_error = connect("finished", self, "_on_self_finished")


func _on_self_finished() -> void:
	if active:
		play()


func stop() -> void:
	active = false
	.stop()


func play(from_position := 0.0) -> void:
	active = true
	.play(from_position)
