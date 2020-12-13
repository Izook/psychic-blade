extends Control

onready var spedometer_node := $HBoxContainer/Spedometer as Node2D

func _ready() -> void:
	pass 


func _process(_delta: float) -> void:
	pass


func get_spedometer() -> Node2D:
	return spedometer_node
