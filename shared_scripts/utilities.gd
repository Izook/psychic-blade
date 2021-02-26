# Utilities 
# Global Singleton
# Contains miscellaneous helper functions.

extends Node

# Constant File/Directory Paths
const VERSION_PATH := "res://VERSION"
const LEVELS_DIR_PATH := "res://scenes/levels/"
const START_SCENE_PATH := "res://scenes/menus/start_menu/start_menu.tscn"

# Constant Scene Paths
const MAIN_PATH := "/root/Main"
const HUD_PATH := "/root/Main/UILayer/HUD"
const ACTIVE_LEVEL_PATH := "/root/Main/GameLayer/Level"
const PLAYER_PATH := "/root/Main/GameLayer/Level/Player"
const START_PATH := "/root/StartMenu"


# Returns the shortest angle difference to get from b to a in 
# radians. 
# Code based on: https://stackoverflow.com/a/28037434
static func get_angle_diff(angle_a: float, angle_b: float) -> float:
	var angle_diff := fmod((angle_b - angle_a + PI), 2 * PI) - PI;
	if angle_diff < -PI:
		angle_diff += 2 * PI
	return angle_diff as float
