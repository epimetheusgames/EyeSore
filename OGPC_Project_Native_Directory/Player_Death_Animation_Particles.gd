extends Node2D
  

func _process(delta):
	if $Timer.time_left <= 0:
		queue_free()

func _physics_process(delta):
	if $Timer.time_left < 0.7:
		position.y += 2
