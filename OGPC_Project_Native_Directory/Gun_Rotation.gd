extends Node2D


onready var player_body = get_node("/root/World_Root_Node/Player_Body")


func _process(delta):
	print(player_body.shoot_direction)
	self.rotation_degrees = int(player_body.shoot_direction)
	print(self.rotation)
