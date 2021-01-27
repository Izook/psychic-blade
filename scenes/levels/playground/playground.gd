extends Node2D

class_name Playground

func _unhandled_input(event: InputEvent) -> void:
	var joypad_motion := event as InputEventJoypadMotion
	if joypad_motion:
		pass
		# print("( ", Input.get_joy_axis(0,0), ", ", Input.get_joy_axis(0,1), ")")

