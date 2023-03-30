extends Node2D

var countdown_player_tel = -1
var block_old_pos = Vector2.ZERO

func _on_Area2D_body_entered(body):
	if "MoveableBlock" in body.name:
		var player = get_parent().get_node("Player_Body")
	
		countdown_player_tel = 10
		block_old_pos = body.position
	
		body.set_telepoint(player.position)

func _process(delta):
	var player = get_parent().get_node("Player_Body")
	if countdown_player_tel > 0:
		countdown_player_tel -= 1
	
	if countdown_player_tel < 5 and countdown_player_tel > 0:
		player.get_node("CollisionShape2D").disabled = true
	
	if countdown_player_tel < 2 and countdown_player_tel > 0:
		player.position = block_old_pos
		
	elif countdown_player_tel == 0:
		player.get_node("CollisionShape2D").disabled = false
		countdown_player_tel = -1
