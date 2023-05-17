extends KinematicBody2D


var velocity = Vector2(0, 0)
var speed = -8
var speed_scaling_amount = 2
var has_been_fired = false
var gravity = 0.3
var self_position = self.position

#onready var player_body = get_parent().get_node("Player_Body")
#const tile_change_liquid_spawner_file_path = preload("res://TileChangeLiquidSpawner.tscn")

func _process(delta):
	self_position = self.position

func _physics_process(_delta):
	var enemies = get_tree().get_nodes_in_group("enemies")
	var bullet_collision_info = move_and_collide(velocity)
	
	if bullet_collision_info != null:
#		Spawn_Tile_Change_Liquid_Spawner(self_position, tile_change_liquid_spawner_file_path)
#
#		if bullet_collision_info.collider.name == "PixelatedBoss":
#			bullet_collision_info.collider.on_Knockback_event()
#		if bullet_collision_info.collider.name.begins_with("Enemy1Body"):
#			bullet_collision_info.collider.die()
#		if bullet_collision_info.collider.name.begins_with("Enemy2Body"):
#			bullet_collision_info.collider.die()
		
		self.queue_free()
#	else:
#		velocity.y += gravity
	
	speed += speed_scaling_amount
	
	if has_been_fired == false:
		print("hi")
		velocity = Vector2(speed, 0)
		has_been_fired = true
	elif has_been_fired == true:
		pass
	
#func Spawn_Tile_Change_Liquid_Spawner(self_position, tile_change_liquid_spawner_file_path):
#	var tile_change_liquid_spawner = tile_change_liquid_spawner_file_path.instance()
#	tile_change_liquid_spawner.position = position
#	get_parent().add_child(tile_change_liquid_spawner)
