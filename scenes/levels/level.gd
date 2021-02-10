extends Node

class_name Level

onready var music_player := $MusicPlayer as AudioStreamPlayer


func _ready() -> void:
	var _conn_error := music_player.connect("finished", self, "_on_MusicPlayer_finished")


func _on_MusicPlayer_finished() -> void:
	music_player.play()
