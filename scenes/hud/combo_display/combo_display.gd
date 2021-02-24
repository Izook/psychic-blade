extends Node2D

class_name ComboDisplay

signal combo_updated(new_combo)

const MAX_COMBO_HIT_TIME := 2.0

onready var current_combo_label := $LockUp/CurrentCombo as Label
onready var combo_timer_bar := $LockUp/ComboTimerBar as ProgressBar 

var current_combo := 0
var combo_time := 0.0


func _process(delta: float) -> void: 
	if combo_time > 0.0:
		combo_time = combo_time - delta
		if combo_time < 0.0:
			combo_time = 0.0
		
		var combo_timer_bar_progress := int((combo_time / MAX_COMBO_HIT_TIME) * 100)
		combo_timer_bar.set_value(combo_timer_bar_progress)
		
		if combo_time == 0.0:
			current_combo = 0
		current_combo_label.set_text("%02d" % current_combo)


func add_to_combo() -> void:
	current_combo = current_combo + 1
	emit_signal("combo_updated", current_combo)
	combo_time = MAX_COMBO_HIT_TIME
