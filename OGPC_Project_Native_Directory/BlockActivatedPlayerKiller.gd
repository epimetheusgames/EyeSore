extends Node2D


func _on_Area2D_body_entered(body):
	if "MoveableBlock" in body.name:
		var player = get_parent().get_node("Player_Body")
		
		var old_player_pos = player.position 
		
		player.position = body.position
		body.set_telepoint(old_player_pos)
		
