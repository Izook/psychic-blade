extends Node2D

class_name BladeDisplay

onready var spedometer_needle := $Spedometer/Guage/Needle as Sprite
onready var spedometer_flame_particles := $Spedometer/FlameParticles as Particles2D
onready var spedometer_ignite_particles := $Spedometer/IgniteParticles as Particles2D

onready var tachometer_needle := $Tachometer/Guage/Needle as Sprite
onready var tachometer_flame_particles := $Tachometer/FlameParticles as Particles2D
onready var tachometer_ignite_particles := $Tachometer/IgniteParticles as Particles2D

var current_speed := 0.0
var max_speed := 100.0
var at_max_speed := false
var max_spedometer_flame_particles := 150

var current_angular_speed := 0.0
var max_angular_speed := 50.0
var at_max_angular_speed := false
var max_tachometer_flame_particles := 75


func set_max_speed(new_max_speed: float) -> void:
	max_speed = new_max_speed


func set_current_speed(new_speed: float) -> void:
	current_speed = new_speed
	_update_spedometer()


func _update_spedometer() -> void:
	var new_speed_index := (current_speed / max_speed)
	
	var new_angle := (new_speed_index * (3 * PI / 2)) - (3 * PI / 4) 
	spedometer_needle.set_rotation(new_angle)
	
	_update_flame_particles(new_speed_index, at_max_speed, spedometer_flame_particles, max_spedometer_flame_particles, spedometer_ignite_particles)


func set_max_angular_speed(new_max_angular_speed: float) -> void:
	max_angular_speed = new_max_angular_speed


func set_current_angular_speed(new_angular_speed: float) -> void:
	current_angular_speed = new_angular_speed
	_update_tachometer()


func _update_tachometer() -> void:
	var new_speed_index := (current_angular_speed / max_angular_speed)
	var new_angle := (new_speed_index * (3 * PI / 2)) - (3 * PI / 4) 
	tachometer_needle.set_rotation(new_angle)
	
	_update_flame_particles(new_speed_index, at_max_angular_speed, tachometer_flame_particles, max_tachometer_flame_particles, tachometer_ignite_particles)


func _update_flame_particles(speed_index: float, at_max: bool, flame_particles: Particles2D, max_flame_particles: int, ignite_particles: Particles2D) -> void:
	if speed_index > 0.75 && speed_index < 0.95:
		if not flame_particles.emitting:
			flame_particles.emitting = true
		if flame_particles.amount != int(max_flame_particles / 2):
			flame_particles.amount = int(max_flame_particles / 2)
	elif speed_index > 0.95:
		if not at_max:
			at_max = true
			ignite_particles.emitting = true
		if !flame_particles.emitting:
			flame_particles.emitting = true
		if flame_particles.amount != max_flame_particles:
			flame_particles.amount = max_flame_particles
	else:
		at_max = false
		flame_particles.emitting = false
