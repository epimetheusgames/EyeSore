extends Node2D
  

func _process(delta):
	if $Timer.time_left <= 0:
		queue_free()

func _physics_process(delta):
	if $Timer.time_left > 0.5 and $Timer.time_left < 1.4:
		position.y += 2
	elif $Timer.time_left < 0.5:
		# need to implement all of the player's fragments moving back to the center of the screen and reforming the player then the vignette opening again
		pass
