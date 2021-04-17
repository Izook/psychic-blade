extends Area2D

class_name ExitGate


onready var hitbox := $HitBox as StaticBody2D


var active := false


func set_active(new_active: bool):
	active = new_active
	
	set_monitoring(active)
	hitbox.set_collision_layer_bit(Utils.ENTITIES_COLLISION_LAYER, active)
	hitbox.set_collision_mask_bit(Utils.ENTITIES_COLLISION_LAYER, active)
	hitbox.set_collision_layer_bit(Utils.BLADE_COLLISION_LAYER, active)
	hitbox.set_collision_mask_bit(Utils.BLADE_COLLISION_LAYER, active)


func _on_ExitGate_body_entered(body: Node) -> void:
	var player = body as Player
	if active and player: 
		print("THE PLAYER IS EXITING!")
