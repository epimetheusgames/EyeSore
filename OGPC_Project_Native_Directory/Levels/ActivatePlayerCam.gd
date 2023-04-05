extends AudioStreamPlayer


# This activates the player's camera.

func _process(delta):
	get_parent().get_node("Player_Body").get_node("Camera2D").current = true
