extends Node2D

class_name HeartIcon

onready var icon_sprite := $Sprite as Sprite

onready var heart_empty_sprite := load(get_script().resource_path + "/../heart_empty.png")
onready var heart_full_sprite := load(get_script().resource_path + "/../heart_full.png")

func empty() -> void:
	icon_sprite.set_texture(heart_empty_sprite)

func refill() -> void:
	icon_sprite.set_texture(heart_full_sprite)
