extends Node2D

class_name LevelDisplay

onready var stopwatch_label := $StopWatch/Time as Label

var elapsed_time := 0


func _process(delta):
	elapsed_time = int(elapsed_time + (delta * 1000))
	var minutes = elapsed_time / (60 * 1000)
	var seconds = (elapsed_time / 1000) % (60)
	var milliseconds = (elapsed_time % 1000) / 10
	
	var elapsed_time_string = "%02d:%02d.%02d" % [minutes, seconds, milliseconds]
	stopwatch_label.set_text(elapsed_time_string)