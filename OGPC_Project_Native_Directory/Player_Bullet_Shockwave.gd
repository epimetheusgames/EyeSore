extends Area2D

var grow = 0.01
var grow_amount = 1.4
var speedup_timer = 38
var despawn_timer = 82

var used = false
var player_hit = false

var body_collided_with

var player_shockwave_bullet_node_self = self


func _physics_process(delta):
	if body_collided_with == "Player_Body" or speedup_timer <= 0:
		used = true
	else:
		used = false
	
	if used == false:
		self.scale = Vector2(grow, grow)
		grow += grow_amount
		speedup_timer -= 1
	elif used == true:
		player_hit = true
		grow_amount = 5.5
		
		
		self.scale = Vector2(grow, grow)
		grow += grow_amount
	
	if despawn_timer <= 0:
		self.queue_free()
	
	despawn_timer -= 1


func _on_Player_Bullet_Shockwave_body_entered(body):
	if used == false:
		body_collided_with = body.name
		if body_collided_with == "Player_Body":
			get_parent().get_node("Player_Body").Shockwave_Hit_Player(player_shockwave_bullet_node_self)
