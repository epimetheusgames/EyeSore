extends Node2D

var file_name = "user://save1.json"
onready var pixelated_boss = preload("res://PixelatedBoss.tscn")
onready var enemy1 = preload("res://Enemy1.tscn")
onready var enemy2 = preload("res://Enemy2.tscn")
onready var player = preload("res://Player.tscn")
export var load_saved_game = true

# This is a temporary dictionary for saving and loading.
# When the game is finished, it will be a simple level
# system and maybe some other properties like health.

var default_data = {
	"player": {
		"health": 36.0,
		"position_x": 0, # Add player starting position here 
		"position_y": 0,
		"respawn_position_x": 0, # Add respawn here too
		"respawn_position_y": 0 
	},
	"pixelated_boss": {},
	"zombie_enemies": {}, 
	"patrolling_enemies": {},
}

var game_loaded = false

func load_game():
	var file = File.new()
	var data
	
	if not file.file_exists(file_name):
		data = default_data
	
	else:
		file.open(file_name, file.READ)
		data = parse_json(file.get_as_text())
		
	while get_node("Player_Body"):
		remove_child(get_node("Player_Body"))
		
	player = player.instance()
	player.player_health = data["player"]["health"]
	player.position.x = data["player"]["position_x"]
	player.position.y = data["player"]["position_y"]
	player.respawn_position.x = data["player"]["respawn_position_x"]
	player.respawn_position.y = data["player"]["respawn_position_y"]
	add_child(player)
	
	if data["pixelated_boss"]:
		var pb = pixelated_boss.instance()
		pb.health = data["pixelated_boss"]["health"]
		pb.position.x = data["pixelated_boss"]["position_x"]
		pb.position.y = data["pixelated_boss"]["position_y"]
		add_child(pb)
	
	for e1dat in data["zombie_enemies"]:
		var enemy = enemy1.instance()
		enemy.position.x = e1dat["position_x"]
		enemy.position.y = e1dat["position_y"]
		add_child(enemy)
		
	for e2dat in data["patrolling_enemies"]:
		var enemy = enemy2.instance()
		enemy.position.x = e2dat["position_x"]
		enemy.position.y = e2dat["position_y"]
		enemy.point1.x = e2dat["start_position_x"]
		enemy.point1.y = e2dat["start_position_y"]
		enemy.point2.x = e2dat["end_position_x"]
		enemy.point2.y = e2dat["end_position_y"]
		add_child(enemy)

func get_data():
	var data = {
		"player": {
			"health": $Player_Body.player_health,
			"position_x": $Player_Body.position.x,
			"position_y": $Player_Body.position.y,
			"respawn_position_x": $Player_Body.respawn_position.x,
			"respawn_position_y": $Player_Body.respawn_position.y
		},
		"pixelated_boss": {},
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
	file.open(file_name, File.WRITE)
	file.store_line(to_json(data))
	file.close()

func _process(delta):
	if not game_loaded and load_saved_game:
		game_loaded = true 
		
		load_game()
		
	if Input.is_action_just_pressed("self_destruct"):
		save_game()
