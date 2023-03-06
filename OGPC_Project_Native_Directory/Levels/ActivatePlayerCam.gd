extends AudioStreamPlayer


func _process(delta):
	get_parent().get_node("Player_Body").get_node("Camera2D").current = true
