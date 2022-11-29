extends KinematicBody2D


var velocity = Vector2(0, 0)
var speed = 150
var speed_scaling_amount = 20
var has_been_fired = false
var die_on_next_frame = false

onready var player_body = get_node("/root/World_Root_Node/Player_Body")

func _physics_process(_delta):
	var enemies = get_tree().get_nodes_in_group("enemies")
	var bullet_collision_info = move_and_collide(velocity)
	
	if die_on_next_frame:
		self.queue_free()
	
	if bullet_collision_info != null:
		die_on_next_frame = true
		if bullet_collision_info.collider.name == "InfiniteHealthBoss":
			bullet_collision_info.collider.on_Knockback_event()
	
	speed += speed_scaling_amount
	
	if has_been_fired == false:
		if player_body.shoot_direction == 0:
			velocity = Vector2(0, -12)
		elif player_body.shoot_direction == 90:
			velocity = Vector2(12, 0)
		elif player_body.shoot_direction == -90:
			velocity = Vector2(-12, 0)
		elif player_body.shoot_direction == 180:
			velocity = Vector2(0, 12)
		elif player_body.shoot_direction == 45:
			velocity = Vector2(6, -6)
		elif player_body.shoot_direction == -45:
			velocity = Vector2(-6, -6)
		elif player_body.shoot_direction == 135:
			velocity = Vector2(6, 6)
		elif player_body.shoot_direction == -135:
			velocity = Vector2(-6, 6)
		else:
			velocity = Vector2(12, 0)
		
		has_been_fired = true
