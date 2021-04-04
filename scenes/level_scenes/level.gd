extends Node

class_name Level


func _clear_tilemap_collision_bits(tilemap: TileMap) -> void:
	tilemap.set_collision_layer_bit(Utils.ENTITIES_COLLISION_LAYER, false)
	tilemap.set_collision_mask_bit(Utils.ENTITIES_COLLISION_LAYER, false)
	tilemap.set_collision_layer_bit(Utils.BLADE_COLLISION_LAYER, false)
	tilemap.set_collision_mask_bit(Utils.BLADE_COLLISION_LAYER, false)
