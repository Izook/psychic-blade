# UI Utilities 
# Global Singleton
# Contains functions to update and interact with UI (User Interface) and HUD
# (Heads Up Display)

extends Node

var hud_node : MarginContainer
var spedometer_node : Node2D

func _ready() -> void:
	yield(get_node("/root/Main"), "ready")
	_main_ready()


func _main_ready() -> void:
	hud_node = get_node("/root/Main/UILayer/HUD")
	spedometer_node = hud_node.spedometer_node


# Sets the speeds for the spedometer to adjust the spedometers dial
static func set_spedometer_speeds(max_speed: float) -> void:
	pass

# Updates the speed that the spedometer is currently displaying
static func update_spedometer(new_speed: float) -> void:
	pass
