extends Node2D

class_name PlayerDash

onready var hearts := [
	$LockUp/Hearts/HeartIcon1,
	$LockUp/Hearts/HeartIcon2,
	$LockUp/Hearts/HeartIcon3,
	$LockUp/Hearts/HeartIcon4,
	$LockUp/Hearts/HeartIcon5,
]

onready var dashes := [
	$LockUp/Dashes/DashIcon1,
	$LockUp/Dashes/DashIcon2,
	$LockUp/Dashes/DashIcon3,
]

var max_health : int
var max_dashes : int


func set_max_health(health: int):
	max_health = health
	for i in hearts.size():
		if i > max_health - 1:
			hearts[i].set_visible(false)


func set_max_dashes(dash_count: int):
	max_dashes = dash_count
	for i in dashes.size():
		if i > max_dashes - 1:
			dashes[i].set_visible(false)


func _on_Player_health_changed(new_health: int):
	for i in hearts.size():
		if i <= new_health - 1:
			hearts[i].refill()
		else:
			hearts[i].empty()


func _on_Player_dashes_changed(new_dashes: int):
	for i in dashes.size():
		print(i)
		if i <= new_dashes - 1:
			dashes[i].refill()
		else:
			dashes[i].empty()



