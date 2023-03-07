extends Node2D


export var next_level = ""
export var previous_level = ""
export var current_level_number = -1
export var is_wire_ui = false
export var can_wire_ui = true

var health
var player_position
var spawnpoint
var enemy1s
var enemy2s
var pixelated_bosses

var loaded = false
var deleted_spikes = []
var deleted_spike_types = []
var wire_terminals = [] # this will end up being a list of all the nodes in the wire terminal group so the script can iterate through them and check if the player is in range of any of them
var in_range_of_wire_terminal = false

onready var wire_scene = preload("res://Wire.tscn")

func convert2list(dict):
	return Array(dict.values())
	
func loading_edge_case_handler(node, list, item): # Handle edge cases that may happen while loading the game
	if node >= len(list) - 1: # Check if the index of the node is greater than the index
		# of the ammount of saved positions in the passed in data so that we don't get an error.
		if len(list) == 0:
			item.queue_free()
			return 2
		if list[0] != null: # If this is null than it means that the game has not been saved.
			item.queue_free() # If it is not null, than this is an unwanted item, because the game 
			# Was saved but this item was not saved. Ideally this won't happen, but this is here
			# For an edge case.
			return 2
		else:
			$Save_Functionality/Player_Body.position = player_position
			$Save_Functionality/Player_Body.player_health = health
			return 1 # Break out of the loop if it's not an unwanted item because those are already
			# loaded in. At least that keyword should be triggered outside this function
	return 0
	
func set_player_spawnpoint_and_position(healthp, player_positionp, spawnpointp, enemy1sp, enemy2sp, pixelated_bossesp):
	# This function is responsible for setting all of that stuff that the player would
	# Explode if they didn't have. I know right remove one line of code and you could 
	# Reset your health just by clicking exit to menu. Lol that I didn't let that happen.
	# I sound very stuckup don't I
	health = healthp
	enemy1s = enemy1sp 
	enemy2s = enemy2sp 
	pixelated_bosses = pixelated_bossesp

func set_player_spawnpoint_and_position_reality(health, player_position, spawnpoint, enemy1s, enemy2s, pixelated_bosses, tree):
	# The function above, but all those crazy exploits are fixed but I wanted to keep
	# that for reference. and other functions break without it so I'll just keep it.
	
	# BTW The player's position isn't actually set here (lol), it used to but it doesn't
	# Now it's set in the _ready function in Save_Functionality so that custom spawnpoints
	# Could be a thing, but I didn't want to change the name and it's still somewhat
	# (WELL ...) relevant.
	
	# Actually, pretty much this entire function is obsolete now because since our levels
	# are probably going to be much shorter now, in puzzle form, we don't need to save 
	# the exact position of everything, but I'm too lazy to take it out altogether.
	
	var enemy1_nodes = tree.get_nodes_in_group("enemy1group")
	var enemy2_nodes = tree.get_nodes_in_group("enemy2group")
	var pixelated_boss = tree.get_nodes_in_group("pixelated_boss")
	if len(pixelated_boss) > 0:
		pixelated_boss = pixelated_boss[0]
	#var enemy1s_list = convert2list(enemy1s)
	#var enemy2s_list = convert2list(enemy2s)
	
	#for enemy1_node in range(len(enemy1_nodes)):
	#	var item = enemy1_nodes[enemy1_node]
	#	var status = loading_edge_case_handler(enemy1_node, enemy1s_list, item)
	#	
	#	if status == 2:
	#		continue 
	#	elif status == 1:
	#		break
	#	
	#	item.position.x = enemy1s_list[enemy1_node]["position_x"] # Set the node's x and y position to the 
	#	item.position.y = enemy1s_list[enemy1_node]["position_y"] # saved data.
	#
	#for enemy2_node in range(len(enemy2_nodes)):
	#	var item = enemy2_nodes[enemy2_node]
	#	var status = loading_edge_case_handler(enemy2_node, enemy2s_list, item)
	#	
	#	if status == 2:
	#		continue 
	#	elif status == 1:
	#		break
	#	
	#	item.position.x = enemy2s_list[enemy2_node]["position_x"]
	#	item.position.y = enemy2s_list[enemy2_node]["position_y"] 
	#	item.point1.x = enemy2s_list[enemy2_node]["start_position_x"]
	#	item.point1.y = enemy2s_list[enemy2_node]["start_position_y"]
	#	item.point2.x = enemy2s_list[enemy2_node]["end_position_x"]
	#	item.point2.y = enemy2s_list[enemy2_node]["end_position_y"]

func is_point_on_connections(point):
	var mouse_on_map = $Save_Functionality/Connections_TileMap.world_to_map(point)
	
	if not $Save_Functionality/Connections_TileMap.get_cell(mouse_on_map.x, mouse_on_map.y) == -1:
		return true
	return false
	
func get_pos_on_tilemap(point):
	return $Save_Functionality/Connections_TileMap.world_to_map(point)
	
func is_spike_or_grass(point):
	if $Save_Functionality/Spikes_TileMap.get_cell(point.x, point.y) != -1:
		return 's'
	elif $Save_Functionality/TileMap.get_cell(point.x, point.y) != -1:
		return 'g'
	else:
		return 'n'
	
func is_another_already_there(wire_side, not_this_one=null):
	for wire in get_tree().get_nodes_in_group("wires"):
		if not_this_one:
			if not_this_one == wire:
				continue
		var wire_tileset = wire.get_tileset_coords(wire_side, $Save_Functionality/Connections_TileMap)
		var mouse_tileset = $Save_Functionality/Connections_TileMap.world_to_map(get_local_mouse_position())
		
		if wire_tileset == mouse_tileset and (wire.moveable or (not wire.can_connect_with_immoveable and wire_side == 0)):
			return true
	return false
	
		
func _process(delta):
	check_for_in_range_terminals()
	
	if Input.is_action_just_pressed("ui_pause"):
		get_parent().Open_Pause_Menu()
		
	var any_wires_selected = false 
	
	for wire in get_tree().get_nodes_in_group("wires"):
		wire.tileset = $Save_Functionality/TileMap
		if wire.is_selected():
			any_wires_selected = true 

	if is_wire_ui and Input.is_action_just_pressed("mouse_right_click") and not any_wires_selected and is_point_on_connections(get_local_mouse_position()):
		var already_there = is_another_already_there(1)
		
		if not already_there:
			var wire = wire_scene.instance()
			wire.set_pos(get_local_mouse_position())
			wire._on_Side1_button_down()
			get_node("Save_Functionality").add_child(wire)
		
	if Input.is_action_just_pressed("switch_wire_ui") and can_wire_ui and in_range_of_wire_terminal:
		is_wire_ui = not is_wire_ui
	elif Input.is_action_just_pressed("switch_wire_ui") and is_wire_ui == true:
		is_wire_ui = false
	
	var wire_ui_box = get_node("Save_Functionality").get_node("WireUIBox")
	var player = get_node("Save_Functionality").get_node("Player_Body")
	
	if is_wire_ui:
		wire_ui_box.visible = true
		$Save_Functionality/Connections_TileMap.visible = true
		player.force_death()
		player.pause()
		
		for wire in get_tree().get_nodes_in_group("wires"):
			wire.wire_ui = true
	else:
		player.unpause()
		wire_ui_box.visible = false
		$Save_Functionality/Connections_TileMap.visible = false
		
		for wire in get_tree().get_nodes_in_group("wires"):
			wire.wire_ui = false
			wire.unselect()
		
	if not loaded:
		loaded = true 
		set_player_spawnpoint_and_position_reality(health, player_position, spawnpoint, enemy1s, enemy2s, pixelated_bosses, get_tree())

func check_for_in_range_terminals():
	wire_terminals = get_tree().get_nodes_in_group("Wire_Terminal")
	for i in wire_terminals:
		in_range_of_wire_terminal = false
		if i.is_in_use_range == true:
			in_range_of_wire_terminal = true
