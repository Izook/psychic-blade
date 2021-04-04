extends Level

class_name Tutorial

onready var success_sound_player := $SuccessSoundPlayer as AudioStreamPlayer

onready var blade_spinning_braziers := $BladeSpinningRoom/Braziers.get_children()
onready var blade_spinning_door := $BladeSpinningRoom/Doors as TileMap
onready var blade_spinning_door_sprites := $BladeSpinningRoom/DoorsSprites as TileMap

onready var radius_changing_brazier := $RadiusChangingRoom/Braziers/Brazier1 as Brazier
onready var radius_changing_door := $RadiusChangingRoom/Doors as TileMap
onready var radius_chaning_door_sprites := $RadiusChangingRoom/DoorsSprites as TileMap

onready var blade_throwing_brazier := $BladeThrowingRoom/Braziers/Brazier1 as Brazier
onready var blade_throwing_door := $BladeThrowingRoom/Doors as TileMap
onready var blade_throwing_sprites := $BladeThrowingRoom/DoorSprites as TileMap

onready var obstacles_room_single_row_fire_traps := $ObsctaclesRoom/SingleRowFireTraps.get_children()
onready var obstacles_room_four_row_fire_traps := $ObsctaclesRoom/DoubleRowFireTraps.get_children()
onready var obstacles_room_checkerboard_fire_traps_squares := $ObsctaclesRoom/CheckerBoardFireTraps.get_children()
onready var obstacles_room_brazier_fire_traps := $ObsctaclesRoom/BrazierFireTraps.get_children()
onready var obstacles_door := $ObsctaclesRoom/Doors as TileMap
onready var obstacles_door_sprites := $ObsctaclesRoom/DoorSprites as TileMap

var cleared_blade_spinning_room := false
var cleared_radius_changing_room := false
var cleared_blade_throwing_room := false
var cleared_obstacles_room := false


func _ready() -> void:
	
	for brazier in blade_spinning_braziers:
		brazier.connect("put_out", self, "_on_BladeSpinningBrazier_put_out")
		
	radius_changing_brazier.connect("put_out", self, "_on_RadiusChangingBrazier_put_out")
	blade_throwing_brazier.connect("put_out", self, "_on_BladeThrowingBrazier_put_out")
	
	for i in obstacles_room_checkerboard_fire_traps_squares.size():
		for fire_trap in obstacles_room_checkerboard_fire_traps_squares[i].get_children():
			fire_trap.set_offset(i * (fire_trap.ignite_interval / 4))
	
	for fire_trap in obstacles_room_brazier_fire_traps:
		fire_trap.make_everlasting()


func _on_BladeSpinningBrazier_put_out() -> void:
	var any_brazier_lit := false
	for brazier in blade_spinning_braziers:
		brazier = brazier as Brazier
		any_brazier_lit = any_brazier_lit or brazier.get_is_lit()
	
	if not any_brazier_lit:
		if not cleared_blade_spinning_room:
			success_sound_player.play()
			blade_spinning_door.visible = false
			blade_spinning_door_sprites.visible = false
			_clear_tilemap_collision_bits(blade_spinning_door)
			cleared_blade_spinning_room = true


func _on_RadiusChangingBrazier_put_out() -> void:
	if not cleared_radius_changing_room:
			success_sound_player.play()
			radius_changing_door.visible = false
			radius_chaning_door_sprites.visible = false
			_clear_tilemap_collision_bits(radius_changing_door)
			cleared_radius_changing_room = true


func _on_BladeThrowingBrazier_put_out() -> void:
	if not cleared_blade_throwing_room:
		success_sound_player.play()
		blade_throwing_door.visible = false
		blade_throwing_sprites.visible = false
		_clear_tilemap_collision_bits(blade_throwing_door)
		cleared_blade_throwing_room = true

		for fire_trap in obstacles_room_single_row_fire_traps:
			fire_trap.make_timed()
		for fire_trap in obstacles_room_four_row_fire_traps:
			fire_trap.make_timed()
		for square in obstacles_room_checkerboard_fire_traps_squares:
			for fire_trap in square.get_children():
				fire_trap.make_timed()


func _on_ObstaclesRoomBrazier_put_out() -> void:
		if not cleared_obstacles_room:
			success_sound_player.play()
			obstacles_door.visible = false
			obstacles_door_sprites.visible = false
			_clear_tilemap_collision_bits(obstacles_door)
			cleared_obstacles_room = true
