extends Obstacle

class_name FireTrap

enum FireTrapState {
	FLAMEOUT,
	SPARKING,
	BLAZING
}

onready var pit_flame_particles := $PitFlameParticles as Particles2D
onready var active_flame_particles := $ActiveFlameParticles as Particles2D 

onready var active_flame_timer := $ActiveFlameTimer as Timer
onready var sparking_flame_timer := $SparkingFlameTimer as Timer
onready var inactive_flame_timer := $InactiveFlameTimer as Timer

onready var collision_shape := $CollisionShape2D as CollisionShape2D

onready var flame_ignite_audio_player := $FlameIgnitePlayer as AudioStreamPlayer2D

export(int) var ignite_interval := 2
export(int) var ignite_offset := 0

var fire_trap_state = FireTrapState.FLAMEOUT
var active := false


func _ready() -> void:
	yield(get_tree().create_timer(ignite_offset), "timeout")
	inactive_flame_timer.start(int(ignite_interval / 2))


func set_active(new_active: bool) -> void:
	active = new_active
	_set_state(fire_trap_state)


func _set_state(new_state: int) -> void:
	
	match new_state:
		FireTrapState.FLAMEOUT:
			inactive_flame_timer.start(int(ignite_interval / 2))
			pit_flame_particles.emitting = false
			active_flame_particles.emitting = false
			collision_shape.set_deferred("disabled", true)
			
			
		FireTrapState.SPARKING:
			sparking_flame_timer.start(ignite_interval)
			if active:
				pit_flame_particles.emitting = true
				active_flame_particles.emitting = false
				collision_shape.set_deferred("disabled", true)
		
		FireTrapState.BLAZING:
			active_flame_timer.start(int(ignite_interval / 2))
			if active:
				pit_flame_particles.emitting = true
				active_flame_particles.emitting = true
				collision_shape.set_deferred("disabled", false)
				flame_ignite_audio_player.play()
	
	fire_trap_state = new_state


func _on_ActiveFlameTimer_timeout() -> void:
	_set_state(FireTrapState.FLAMEOUT)


func _on_SparkingFlameTimer_timeout() -> void:
	_set_state(FireTrapState.BLAZING)


func _on_InactiveFlameTimer_timeout() -> void:
	_set_state(FireTrapState.SPARKING)
