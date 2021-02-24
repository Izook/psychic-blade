extends Node2D

class_name LevelDisplay

onready var stopwatch_label := $StopWatch/Time as Label
onready var kill_count_label := $KillCounter/KillCount as Label
onready var highest_combo_label := $HighestCombo/Count as Label

var elapsed_time := 0
var kill_count := 0
var highest_combo := 0


func _process(delta: float) -> void:
	elapsed_time = int(elapsed_time + (delta * 1000))
	var minutes = elapsed_time / (60 * 1000)
	var seconds = (elapsed_time / 1000) % (60)
	var milliseconds = (elapsed_time % 1000) / 10
	
	var elapsed_time_string := "%02d:%02d.%02d" % [minutes, seconds, milliseconds]
	stopwatch_label.set_text(elapsed_time_string)


func add_kill() -> void:
	kill_count = kill_count + 1
	
	var kill_count_string := "x %02d" % kill_count
	kill_count_label.set_text(kill_count_string)


func _on_ComboDisplay_combo_updated(new_combo: int) -> void:
	if new_combo > highest_combo:
		highest_combo = new_combo
		
		var highest_combo_string := "Highest Combo: %02d" % highest_combo
		highest_combo_label.set_text(highest_combo_string)
	
