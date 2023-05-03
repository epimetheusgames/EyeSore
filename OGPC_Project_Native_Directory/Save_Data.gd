extends Node2D

var file_name = "user://save1.json"
var keybind_file_name = "user://keybinds.json"
onready var pixelated_boss = preload("res://PixelatedBoss.tscn")
onready var enemy1 = preload("res://Enemy1.tscn")
onready var enemy2 = preload("res://Enemy2.tscn")
onready var player = preload("res://Player.tscn")
export var game_save_max = 60
var data = get_file_data()
export var load_saved_game = true
var game_save_time = game_save_max

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
	"pixelated_boss": {"":null},
	"zombie_enemies": {"":null},
	"patrolling_enemies": {"":null},
}

const default_keybind_data = {
	"darkness": 0,
	"sfx-audio": 1,
	"music-audio": 1,
	"respawn-type": 0,
	"respawn": 82,
	"jump-type": 0,
	"jump": 32,
	"left-type": 0,
	"left": 65,
	"right-type": 0,
	"right": 68,
	"terminal-type": 0,
	"terminal": 69
}

func next_level():
	if get_parent().next_level == "end":
		print("You finished, credits!")
	else:
		data["level"] += 1
		save_game()
		get_parent().get_parent().Next_Level(data["level"], get_game_data())

func _ready():
	
	# Yes this is where the player's respawn pos is set.
	var spawn_pos = get_node("PlayerSpawnPos")
	
	if spawn_pos != null:
		# If there is a set spawn pos then do this stuff
		data["player"]["respawn_position_x"] = spawn_pos.position.x
		data["player"]["respawn_position_y"] = spawn_pos.position.y
		$Player_Body.respawn_position = spawn_pos.position
		$Player_Body.position = spawn_pos.position
		$Player_Body.start_position = spawn_pos.position
		print($Player_Body.self_position)
	else: 
		# Otherwise (first check if we're not in the main menu or something,) 
		# set the positions to 0,0. This is just for older scenes to still work.
		if get_node("Player_Body") != null:
			$Player_Body.respawn_position = Vector2.ZERO
			$Player_Body.position = Vector2.ZERO
			$Player_Body.start_position = Vector2.ZERO
			
func save_audio(music, sfx):
	data["keybinds"] = get_game_data()[4]
	data["keybinds"]["music-audio"] = music # Well that's done now. (totally)
	data["keybinds"]["sfx-audio"] = sfx
	
func save_checkpoint(checkpoint_position):
	get_node("Player_Body").respawn_position = checkpoint_position
	data["player"]["respawn_position_x"] = checkpoint_position.x
	data["player"]["respawn_position_y"] = checkpoint_position.y
	
func save_video(darkness):
	data["keybinds"] = get_game_data()[4]
	data["keybinds"]["darkness"] = darkness

func save_keybinds(keybinds):
	var music = data["keybinds"]["music-audio"]
	var sfx = data["keybinds"]["sfx-audio"]
	var darkness = data["keybinds"]["darkness"]
	data["keybinds"] = keybinds
	data["keybinds"]["music-audio"] = music
	data["keybinds"]["sfx-audio"] = sfx
	data["keybinds"]["darkness"] = darkness
	
func set_keybind_data_to_data():
	var file = File.new()
	
	if not file.file_exists(keybind_file_name):
		data = default_keybind_data
	
	else:
		file.open(keybind_file_name, file.READ)
		data["keybinds"] = parse_json(file.get_as_text())
	
func get_game_data():
	var file = File.new()
	var keybind_data = default_keybind_data
	var game_data
	
	if not file.file_exists(file_name):
		game_data = default_data
		
	else:
		file.open(file_name, file.READ)
		game_data = parse_json(file.get_as_text())
		
	if file.file_exists(keybind_file_name):
		file.open(keybind_file_name, file.READ)
		keybind_data = parse_json(file.get_as_text())
		
	return [
		game_data["level"],
		game_data["player"]["health"],
		Vector2(game_data["player"]["position_x"], game_data["player"]["position_y"]),
		Vector2(game_data["player"]["respawn_position_x"], game_data["player"]["respawn_position_y"]),
		keybind_data,
		keybind_data["music-audio"],
		keybind_data["sfx-audio"],
		game_data["zombie_enemies"],
		game_data["patrolling_enemies"],
		game_data["pixelated_boss"]
	]
	
func get_file_data(): # Also don't use this one unless it's from inside this file
	var file = File.new()
	
	if not file.file_exists(file_name):
		data = default_data
	
	else:
		file.open(file_name, file.READ)
		data = parse_json(file.get_as_text())
		
	if not file.file_exists(keybind_file_name):
		data["keybinds"] = default_keybind_data
	
	else:
		file.open(keybind_file_name, file.READ)
		data["keybinds"] = parse_json(file.get_as_text())
	
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
	
	return level_data
	
func save_game():
	var file = File.new()
	var keybinds = data["keybinds"]
	data.erase("keybinds")
	file.open(file_name, File.WRITE)
	file.store_line(to_json(data))
	file.close()
	file.open(keybind_file_name, File.WRITE)
	file.store_line(to_json(keybinds))
	file.close()
	data["keybinds"] = keybinds

func set_keybinds(keybinds, old_keybinds): # Sets all keybinds to what is in data
	InputMap.erase_action("movement_left")
	InputMap.erase_action("movement_right")
	InputMap.erase_action("movement_jump")
	InputMap.erase_action("respawn")
	InputMap.erase_action("switch_wire_ui")
	set_specific_keybind("movement_left", keybinds["left"], keybinds["left-type"])
	set_specific_keybind("movement_right", keybinds["right"], keybinds["right-type"])
	set_specific_keybind("movement_jump", keybinds["jump"], keybinds["jump-type"])
	set_specific_keybind("respawn", keybinds["respawn"], keybinds["respawn-type"])
	set_specific_keybind("switch_wire_ui", keybinds["terminal"], keybinds["terminal-type"])
	
func set_specific_keybind(action, keybind, type): # Sets a specific keybind
	var key
	if not InputMap.get_actions().has(action):
		InputMap.add_action(action)
	if type == 0:
		key = InputEventKey.new()
		key.set_scancode(keybind)
	elif type == 1: # Check for joypad
		key = InputEventJoypadButton.new()
		key.button_index = keybind
	InputMap.action_add_event(action, key)

func delete_specific_keybind(action, event, type):
	var key 
	
	if type == 0:
		key = InputEventKey.new()
		key.set_scancode(event)
	if type == 1:
		key = InputEventJoypadButton.new()
		key.button_index = event
	
	InputMap.action_erase_event(action, key)
