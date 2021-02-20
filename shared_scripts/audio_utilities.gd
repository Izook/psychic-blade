# Audio Utilities 
# Global Singleton
# Contains miscellaneous helper functions for playing/adjusting audio.

extends Node

onready var pitch_shift_effect := AudioEffectPitchShift.new()
onready var notch_filter_effect := AudioEffectNotchFilter.new()
onready var music_bus := AudioServer.get_bus_index("Music")


func _ready() -> void:
	pitch_shift_effect.pitch_scale = 0.25


func set_distort_music(active: bool) -> void:
	if active:
		AudioServer.add_bus_effect(music_bus, pitch_shift_effect)
		AudioServer.add_bus_effect(music_bus, notch_filter_effect)
	else:
		while AudioServer.get_bus_effect_count(music_bus):
			AudioServer.remove_bus_effect(music_bus, 0)


