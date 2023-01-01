extends Node2D

var file_name = "user://save1.json"
onready var pixelated_boss = preload("res://PixelatedBoss.tscn")
onready var enemy1 = preload("res://Enemy1.tscn")
onready var enemy2 = preload("res://Enemy2.tscn")
onready var player = preload("res://Player.tscn")
onready var data = get_file_data()
export var load_saved_game = true

# This is a temporary dictionary for saving and loading.
# When the game is finished, it will be a simple level
# system and maybe some other properties like health.

const default_data = {
	"player": {
		"health": 36.0,
		"position_x": 0, # Add player starting position here 
		"position_y": 0,
		"respawn_position_x": 0, # Add respawn here too
		"respawn_position_y": 0 
	},
	"level": 0,
	"keybinds": {
		"left": "A",
		"right": "D",
		"jump": "SPACE",
		"shockwave": "S",
		"bullet": "X"
	},
	"pixelated_boss": {},
	"zombie_enemies": {},
	"patrolling_enemies": {},
}

const levels = [
	"res://Levels/Level1_Noah's_test_version.tscn", 
]

func save_keybinds(keybinds):
	data["keybinds"] = keybinds 
	
func get_game_data():
	var file = File.new()
	
	if not file.file_exists(file_name):
		data = default_data 
		
	else:
		file.open(file_name, file.READ)
		data = parse_json(file.get_as_text())
		
	return [
		data["level"],
		data["player"]["health"], 
		Vector2(data["player"]["position_x"], data["player"]["position_y"]), 
		Vector2(data["player"]["respawn_position_x"], data["player"]["respawn_position_y"]),
		data["keybinds"],
	]
	
func get_file_data(): # Also don't use this one unless it's from inside this file
	var file = File.new()
	
	if not file.file_exists(file_name):
		data = default_data
	
	else:
		file.open(file_name, file.READ)
		data = parse_json(file.get_as_text())
	
	return data

func get_current_level_data(level):
	var level_data = {
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
		"level": level,
		"keybinds": data["keybinds"]
	}
	
	var pixelated_boss = get_node("PixelatedBoss")
	var enemy1group = get_tree().get_nodes_in_group("enemy1group")
	var enemy2group = get_tree().get_nodes_in_group("enemy2group")
	
	if pixelated_boss:
		level_data["pixelated_boss"] = {
			"health": pixelated_boss.health,
			"position_x": pixelated_boss.position.x,
			"position_y": pixelated_boss.position.y 
		}
		
	for node_ind in range(len(enemy1group)):
		var node = enemy1group[node_ind]
		level_data["zombie_enemies"]["individual_zombie_enemy" + str(node_ind)] = {
			"position_x": node.position.x,
			"position_y": node.position.y
		}
		
	for node_ind in range(len(enemy2group)):
		var node = enemy2group[node_ind]
		level_data["patrolling_enemies"]["individual_patrolling_enemy" + str(node_ind)] = {
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
	file.open(file_name, File.WRITE)
	file.store_line(to_json(data))
	file.close()

func _ready():
	var timer = Timer.new()
	timer.name = "Timer"
	timer.autostart = true
	timer.wait_time = 1
	add_child(timer)

func _process(delta):
	if $Timer.time_left <= 0 and get_parent().get_parent().name != "MainMenu":
		$Timer.start()
		data = get_current_level_data(data["level"])
		save_game()
