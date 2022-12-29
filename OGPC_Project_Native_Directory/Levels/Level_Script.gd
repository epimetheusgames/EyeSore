extends Node2D


export var next_level = ""
export var previous_level = ""
export var current_level_number = -1


func set_player_spawnpoint_and_position(health, player_position, spawnpoint):
	$Level/Player_Body.respawn_position = spawnpoint
	$Level/Player_Body.position = player_position
	$Level/Player_Body.player_health = health
