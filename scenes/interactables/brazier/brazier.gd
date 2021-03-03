extends Area2D

class_name Brazier

signal put_out
signal relit

enum BrazierState {
	FLAME_OUT,
	FLAME_LIT
}

onready var flame_particles := $FlameParticles as Particles2D
onready var flame_reset_timer := $FlameResetTimer as Timer

var brazier_state = BrazierState.FLAME_LIT
var flame_reset_time = 2


func set_state(new_state: int) -> void:
	match new_state:
		BrazierState.FLAME_OUT:
			emit_signal("put_out")
			flame_particles.emitting = false
			flame_reset_timer.start(flame_reset_time)
		BrazierState.FLAME_LIT:
			emit_signal("relit")
			flame_particles.emitting = true
	
	brazier_state = new_state


func _on_Brazier_body_entered(body: Node) -> void:
	var blade := body as BladeHitbox
	if blade:
		set_state(BrazierState.FLAME_OUT)


func _on_FlameResetTimer_timeout() -> void:
	set_state(BrazierState.FLAME_LIT)
