extends Node

class_name Level


func _set_tilemap_collision_bits(tilemap: TileMap, bit_value: bool) -> void:
	tilemap.set_collision_layer_bit(Utils.ENTITIES_COLLISION_LAYER, bit_value)
	tilemap.set_collision_mask_bit(Utils.ENTITIES_COLLISION_LAYER, bit_value)
	tilemap.set_collision_layer_bit(Utils.BLADE_COLLISION_LAYER, bit_value)
	tilemap.set_collision_mask_bit(Utils.BLADE_COLLISION_LAYER, bit_value)

