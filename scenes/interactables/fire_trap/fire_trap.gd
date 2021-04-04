extends Obstacle

class_name FireTrap

enum FireTrapState {
	INACTIVE,
	REFUELLING,
	SPARKING,
	BLAZING,
	EVERLASTING
}


onready var pit_flame_particles := $PitFlameParticles as Particles2D
onready var active_flame_particles := $ActiveFlameParticles as Particles2D 

onready var active_flame_timer := $ActiveFlameTimer as Timer
onready var sparking_flame_timer := $SparkingFlameTimer as Timer
onready var inactive_flame_timer := $InactiveFlameTimer as Timer
onready var reset_timer := $ResetTimer as Timer

onready var collision_shape := $CollisionShape2D as CollisionShape2D

onready var flame_ignite_audio_player := $FlameIgnitePlayer as AudioStreamPlayer2D

export(float) var ignite_interval := 1.25
export(float) var ignite_offset := ignite_interval

var fire_trap_state = FireTrapState.INACTIVE


func _ready() -> void:
	set_offset(ignite_offset)


func set_offset(offset: float) -> void:
	var curr_time := float(OS.get_ticks_msec()) / 1000.0
	var last_reset_time := fposmod(curr_time, offset * 2)
	var next_reset_time := last_reset_time + (offset * 2)
	var time_till_next_reset := next_reset_time - last_reset_time

	reset_timer.start(time_till_next_reset)


func make_inactive() -> void:
	_set_state(FireTrapState.INACTIVE)


func make_everlasting() -> void:
	_set_state(FireTrapState.EVERLASTING)


func make_timed() -> void:
	_set_state(FireTrapState.REFUELLING)


func _set_state(new_state: int) -> void:
	
	match new_state:
		FireTrapState.INACTIVE:
			pit_flame_particles.emitting = false
			active_flame_particles.emitting = false
			collision_shape.set_deferred("disabled", true)
		
		FireTrapState.REFUELLING:
			pit_flame_particles.emitting = false
			active_flame_particles.emitting = false
			collision_shape.set_deferred("disabled", true)
			
		FireTrapState.SPARKING:
			pit_flame_particles.emitting = true
			active_flame_particles.emitting = false
			collision_shape.set_deferred("disabled", true)
		
		FireTrapState.BLAZING:
			pit_flame_particles.emitting = true
			active_flame_particles.emitting = true
			collision_shape.set_deferred("disabled", false)
			flame_ignite_audio_player.play()
		
		FireTrapState.EVERLASTING:
			pit_flame_particles.emitting = true
			active_flame_particles.emitting = true
			collision_shape.set_deferred("disabled", false)
			flame_ignite_audio_player.play()
	
	fire_trap_state = new_state


func _stop_timers() -> void:
	active_flame_timer.stop()
	sparking_flame_timer.stop()
	inactive_flame_timer.stop()


func _on_ActiveFlameTimer_timeout() -> void:
	inactive_flame_timer.start(ignite_interval / 2)
	if  fire_trap_state != FireTrapState.INACTIVE and fire_trap_state != FireTrapState.EVERLASTING: 
		_set_state(FireTrapState.REFUELLING)


func _on_SparkingFlameTimer_timeout() -> void:
	active_flame_timer.start(ignite_interval / 2)
	if  fire_trap_state != FireTrapState.INACTIVE and fire_trap_state != FireTrapState.EVERLASTING: 
		_set_state(FireTrapState.BLAZING)


func _on_InactiveFlameTimer_timeout() -> void:
	sparking_flame_timer.start(ignite_interval)
	if  fire_trap_state != FireTrapState.INACTIVE and fire_trap_state != FireTrapState.EVERLASTING: 
		_set_state(FireTrapState.SPARKING)


func _on_ResetTimer_timeout() -> void:
	inactive_flame_timer.start(ignite_interval / 2)
