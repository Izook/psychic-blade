extends Node

class_name Level

signal completed

func _ready() -> void:
	print("LEVEL READY")
	var main_node := get_node(Utils.MAIN_PATH) as Main
	var _error = connect("completed", main_node, "_on_Level_completed")


func _complete_level() -> void:
	emit_signal("completed")


func _set_tilemap_collision_bits(tilemap: TileMap, bit_value: bool) -> void:
	tilemap.set_collision_layer_bit(Utils.ENTITIES_COLLISION_LAYER, bit_value)
	tilemap.set_collision_mask_bit(Utils.ENTITIES_COLLISION_LAYER, bit_value)
	tilemap.set_collision_layer_bit(Utils.BLADE_COLLISION_LAYER, bit_value)
	tilemap.set_collision_mask_bit(Utils.BLADE_COLLISION_LAYER, bit_value)

