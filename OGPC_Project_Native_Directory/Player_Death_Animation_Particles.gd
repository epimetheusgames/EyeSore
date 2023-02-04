extends Node2D
  

func _process(delta):
	if $Timer.time_left <= 0:
		queue_free()
