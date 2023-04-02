extends Node2D

var particle_gravity_sin = 0

func _process(delta):
	if $Particles2D.process_material.orbit_velocity >= 40:
		return
	particle_gravity_sin += 0.001
	$Particles2D.process_material.orbit_velocity = sin(particle_gravity_sin)
