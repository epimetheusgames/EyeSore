extends Area2D

var grow = 0.01
var grow_amount = 0.8
var timer = 32

var used = false
var player_hit = false

var body_collided_with

var player_shockwave_bullet_node_self = self


func _physics_process(delta):
	if body_collided_with == "Player_Body":
		used = true
	else:
		used = false
	
	if used == false:
		
		self.scale = Vector2(grow, grow)
		grow += grow_amount
		timer -= 1
	elif used == true:
		player_hit = true
		grow_amount = 4
		
		self.scale = Vector2(grow, grow)
		grow += grow_amount


func _on_Player_Bullet_Shockwave_body_entered(body):
	body_collided_with = body.name
	if body_collided_with == "Player_Body":
		get_parent().get_node("Player_Body").Shockwave_Hit_Player(player_shockwave_bullet_node_self)
