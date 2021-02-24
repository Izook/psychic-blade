extends Control

class_name Hud

onready var blade_display_node := $BladeDisplayContainer/BladeDash as BladeDisplay
onready var player_display_node := $PlayerDisplayContainer/PlayerDash as PlayerDisplay
onready var level_display_node := $LevelDisplayContainer/LevelDisplay as LevelDisplay
onready var combo_display_node := $ComboDisplayContainer/ComboDisplay as ComboDisplay

var player_node : Player
var blade_node : Blade


func _ready() -> void:
	combo_display_node.connect("combo_updated", level_display_node, "_on_ComboDisplay_combo_updated")
	
	yield(get_node("/root/Main"), "ready")
	_main_ready()


func _main_ready() -> void:
	player_node = get_node(Utils.PLAYER_PATH)
	blade_node = player_node.get_blade_node()
	
	blade_display_node.set_max_speed(blade_node.get_max_speed())
	blade_display_node.set_max_angular_speed(blade_node.get_max_angular_speed())
	
	player_display_node.set_max_dashes(player_node.get_max_dashes())
	player_display_node.set_max_health(player_node.get_max_health())
	var _error := player_node.connect("health_changed", player_display_node, "_on_Player_health_changed")
	_error = player_node.connect("dashes_changed", player_display_node, "_on_Player_dashes_changed")


func _process(_delta: float) -> void:
	if blade_node:
		blade_display_node.set_current_speed(blade_node.get_current_speed())
		blade_display_node.set_current_angular_speed(abs(blade_node.get_current_angular_speed()))


func _on_Enemy_died() -> void:
	level_display_node.add_kill()
	combo_display_node.add_to_combo()
