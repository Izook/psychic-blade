extends Node2D

class_name DashIcon

onready var icon_sprite := $Sprite as Sprite

onready var dash_empty_sprite := load(get_script().resource_path + "/../dash_empty.png")
onready var dash_full_sprite := load(get_script().resource_path + "/../dash_full.png")

func empty() -> void:
	icon_sprite.set_texture(dash_empty_sprite)

func refill() -> void:
	icon_sprite.set_texture(dash_full_sprite)

