# Canvas Animation Player 
# Global Singleton
# Global singleton used to play/trigger specific animations that applut to the entire 
# game canvas layer.

extends Node

const CANVAS_ANIMATION_PLAYER_PATH = "/root/Main/CanvasAnimationPlayer"

var animation_player : AnimationPlayer

func init() -> void:
	var main_node := get_node(Utils.MAIN_PATH) as Main
	if main_node:
		yield(main_node, "ready")
		animation_player = get_node(CANVAS_ANIMATION_PLAYER_PATH)


func screen_shake() -> void:
	animation_player.play("screenshake")
