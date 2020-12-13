extends Control

onready var spedometer_node := $HBoxContainer/Spedometer as Node2D

var player_node : Node2D
var blade_node : Node2D

func _ready() -> void:
	yield(get_node("/root/Main"), "ready")
	_main_ready()


func _main_ready() -> void:
	player_node = get_node("/root/Main/GameLayer/Player")
	blade_node = player_node.get_blade_node()
	
	spedometer_node.set_max_speed(blade_node.get_max_speed())


func _process(_delta: float) -> void:
	if blade_node:
		spedometer_node.set_current_speed(blade_node.get_current_speed())
