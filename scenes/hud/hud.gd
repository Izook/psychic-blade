extends Control

class_name Hud

onready var blade_dash_node := $HBoxContainer/BladeDash as BladeDash


var player_node : Player
var blade_node : Blade

func _ready() -> void:
	yield(get_node("/root/Main"), "ready")
	_main_ready()


func _main_ready() -> void:
	player_node = get_node(Utils.PLAYER_PATH)
	blade_node = player_node.get_blade_node()
	
	blade_dash_node.set_max_speed(blade_node.get_max_speed())
	blade_dash_node.set_max_angular_speed(blade_node.get_max_angular_speed())
	


func _process(_delta: float) -> void:
	if blade_node:
		blade_dash_node.set_current_speed(blade_node.get_current_speed())
		blade_dash_node.set_current_angular_speed(blade_node.get_current_angular_speed())
