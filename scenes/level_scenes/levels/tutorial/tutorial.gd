extends Level

class_name Tutorial

onready var success_sound_player := $SuccessSoundPlayer as AudioStreamPlayer

onready var blade_spinning_braziers := [
	$BladeSpinningRoom/Braziers/Brazier1,
	$BladeSpinningRoom/Braziers/Brazier2,
	$BladeSpinningRoom/Braziers/Brazier3,
	$BladeSpinningRoom/Braziers/Brazier4
] as Array
onready var blade_spinning_door := $BladeSpinningRoom/Doors as TileMap

onready var radius_changing_brazier := $RadiusChangingRoom/Braziers/Brazier1 as Brazier
onready var radius_changing_door := $RadiusChangingRoom/Doors as TileMap

onready var blade_throwing_brazier := $BladeThrowingRoom/Braziers/Brazier1 as Brazier
onready var blade_throwing_door := $BladeThrowingRoom/Doors as TileMap

var cleared_blade_spinning_room := false
var cleared_radius_changing_room := false
var cleared_blade_throwing_room := false

func _ready() -> void:
	
	for brazier in blade_spinning_braziers:
		brazier.connect("put_out", self, "_on_BladeSpinningBrazier_put_out")
		
	radius_changing_brazier.connect("put_out", self, "_on_RadiusChangingBrazier_put_out")
	blade_throwing_brazier.connect("put_out", self, "_on_BladeThrowingBrazier_put_out")


func _on_BladeSpinningBrazier_put_out() -> void:
	var any_brazier_lit := false
	for brazier in blade_spinning_braziers:
		brazier = brazier as Brazier
		any_brazier_lit = any_brazier_lit or brazier.get_is_lit()
	
	if not any_brazier_lit:
		if not cleared_blade_spinning_room:
			success_sound_player.play()
			blade_spinning_door.visible = false
			blade_spinning_door.set_collision_layer_bit(Utils.ENTITIES_COLLISION_LAYER, false)
			blade_spinning_door.set_collision_mask_bit(Utils.ENTITIES_COLLISION_LAYER, false)
			blade_spinning_door.set_collision_layer_bit(Utils.BLADE_COLLISION_LAYER, false)
			blade_spinning_door.set_collision_mask_bit(Utils.BLADE_COLLISION_LAYER, false)
			cleared_blade_spinning_room = true


func _on_RadiusChangingBrazier_put_out() -> void:
	if not cleared_radius_changing_room:
			success_sound_player.play()
			radius_changing_door.visible = false
			radius_changing_door.set_collision_layer_bit(Utils.ENTITIES_COLLISION_LAYER, false)
			radius_changing_door.set_collision_mask_bit(Utils.ENTITIES_COLLISION_LAYER, false)
			radius_changing_door.set_collision_layer_bit(Utils.BLADE_COLLISION_LAYER, false)
			radius_changing_door.set_collision_mask_bit(Utils.BLADE_COLLISION_LAYER, false)
			cleared_radius_changing_room = true


func _on_BladeThrowingBrazier_put_out() -> void:
	if not cleared_blade_throwing_room:
		success_sound_player.play()
		blade_throwing_door.visible = false
		blade_throwing_door.set_collision_layer_bit(Utils.ENTITIES_COLLISION_LAYER, false)
		blade_throwing_door.set_collision_mask_bit(Utils.ENTITIES_COLLISION_LAYER, false)
		blade_throwing_door.set_collision_layer_bit(Utils.BLADE_COLLISION_LAYER, false)
		blade_throwing_door.set_collision_mask_bit(Utils.BLADE_COLLISION_LAYER, false)
		cleared_blade_throwing_room = true
