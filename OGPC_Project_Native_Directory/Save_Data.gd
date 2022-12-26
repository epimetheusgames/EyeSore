extends Node2D

var file_name = "user://save1.json"

func get_data():
	var data = {
		"player": {
			"health": $Player_Body.player_health,
			"position_x": $Player_Body.position.x,
			"position_y": $Player_Body.position.y,
			"respawn_position_x": $Player_Body.respawn_position.x,
			"respawn_position_y": $Player_Body.respawn_position.y
		},
		"zombie_enemies": {},
		"patrolling_enemies": {},
	}
	
	var pixelated_boss = get_node("PixelatedBoss")
	var enemy1group = get_tree().get_nodes_in_group("enemy1group")
	var enemy2group = get_tree().get_nodes_in_group("enemy2group")
	
	if pixelated_boss:
		data["pixelated_boss"] = {
			"health": pixelated_boss.health,
			"position_x": pixelated_boss.position.x,
			"position_y": pixelated_boss.position.y 
		}
		
	for node_ind in range(len(enemy1group)):
		var node = enemy1group[node_ind]
		data["zombie_enemies"]["individual_zombie_enemy" + str(node_ind)] = {
			"position_x": node.position.x,
			"position_y": node.position.y
		}
		
	for node_ind in range(len(enemy2group)):
		var node = enemy2group[node_ind]
		data["patrolling_enemies"]["individual_patrolling_enemy" + str(node_ind)] = {
			"position_x": node.position.x, 
			"position_y": node.position.y,
			"start_position_x": node.point1.x,
			"start_position_y": node.point1.y,
			"end_position_x": node.point2.x,
			"end_position_y": node.point2.y
		}
	
	return data
	
func save_game():
	var file = File.new()
	var data = get_data()
	print(file.open(file_name, File.WRITE))
	file.store_line(to_json(data))
	file.close()

func _process(delta):
	if Input.is_action_just_pressed("self_destruct"):
		save_game()
