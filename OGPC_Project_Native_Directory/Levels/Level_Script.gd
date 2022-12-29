extends Node2D


export var next_level = ""
export var previous_level = ""
export var current_level_number = -1


func set_player_spawnpoint_and_position(health, player_position, spawnpoint):
	$Save_Functionality/Player_Body.respawn_position = spawnpoint
	$Save_Functionality/Player_Body.position = player_position
	$Save_Functionality/Player_Body.player_health = health
