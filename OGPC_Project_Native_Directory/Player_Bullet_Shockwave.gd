extends Area2D

var grow = 0.001
var grow_amount = 1.1
var speedup_timer = 18
var player_use_timer = 20
var despawn_timer = 40

var used = false
var player_hit = false

var body_collided_with

var player_shockwave_bullet_node_self = self


func _ready():
	$Explosion_Particles.emitting = true
	$Sprite.modulate = Color(1, 1, 1, 1)

func _physics_process(delta):
	if $Pulse_Timer.time_left > 0.02 and $Pulse_Timer.time_left < 0.05:
		self.scale += Vector2(6, 6)
		$Sprite.modulate = Color(1, 1, 1, 1)
	
	if player_use_timer <= 0 or player_hit == true:
		used = true
	else:
		used = false
	
	if used == false:
		self.scale = Vector2(grow, grow)
		grow += grow_amount
		speedup_timer -= 1
		player_use_timer -= 1
	elif used == true:
		player_hit = true
		grow_amount = 4.8
		self.scale = Vector2(grow, grow)
		grow += grow_amount
	
	if despawn_timer <= 0:
		self.queue_free()
	
	despawn_timer -= 1


func _on_Player_Bullet_Shockwave_body_entered(body):
	if used == false:
		body_collided_with = body.name
		if body_collided_with == "Player_Body":
			$Pulse_Timer.start(0.2)
			$Sprite.modulate = Color(2, 2, 3.2, 2)
			self.scale -= Vector2(15, 15)
			# play shockwave boost SFX
			get_node("/root/MainMenuRootNode/Shockwave_Boost_SFX_Player").play()
			# send signal to boost player
			get_parent().get_node("Player_Body").Shockwave_Hit_Player(player_shockwave_bullet_node_self)
