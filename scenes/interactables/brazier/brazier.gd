extends Area2D

class_name Brazier

signal put_out
signal relit

enum BrazierState {
	FLAME_OUT,
	FLAME_LIT
}

onready var flame_particles := $FlameParticles as Particles2D
onready var sparks_particles := $SparkParticles as Particles2D
onready var flame_reset_timer := $FlameResetTimer as Timer
onready var relit_audio_player := $RelitAudioPlayer as AudioStreamPlayer2D
onready var put_out_audio_player := $PutOutAudioPlayer as AudioStreamPlayer2D

var brazier_state = BrazierState.FLAME_LIT
var flame_reset_time := 2


func get_is_lit() -> bool:
	return brazier_state == BrazierState.FLAME_LIT


func set_state(new_state: int) -> void:
	
	match new_state:
		BrazierState.FLAME_OUT:
			flame_particles.emitting = false
			flame_reset_timer.start(flame_reset_time)
			
			if brazier_state == BrazierState.FLAME_LIT:
				sparks_particles.emitting = true
				put_out_audio_player.play()
				brazier_state = new_state
				yield(put_out_audio_player, "finished")
				emit_signal("put_out")
			
		BrazierState.FLAME_LIT:
			flame_particles.emitting = true
			
			if brazier_state == BrazierState.FLAME_OUT:
				sparks_particles.emitting = true
				relit_audio_player.play()
				brazier_state = new_state
				yield(relit_audio_player, "finished")
				emit_signal("relit")


func _on_Brazier_body_entered(body: Node) -> void:
	var blade := body as BladeHitbox
	if blade:
		set_state(BrazierState.FLAME_OUT)


func _on_FlameResetTimer_timeout() -> void:
	set_state(BrazierState.FLAME_LIT)
