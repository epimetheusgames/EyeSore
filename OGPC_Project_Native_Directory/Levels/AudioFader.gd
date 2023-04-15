extends AudioStreamPlayer


var fadein = false 
var fadeout = false 
var fade_prog = 0
onready var max_volume = volume_db

func _process(delta):
	if fadein and fade_prog < max_volume:
		fade_prog += 1
	else:
		fadein = false
		
	if fadeout and fade_prog > 0:
		fade_prog -= 1
	else:
		fadeout = false
	
	volume_db = fade_prog
