extends KinematicBody2D


var velocity = Vector2(0, 0)
var speed = 5
var speed_scaling_amount = 2
var has_been_fired = false
var gravity = 0.07

onready var player_body = get_parent().get_node("Player_Body")

func _physics_process(_delta):
	var enemies = get_tree().get_nodes_in_group("enemies")
	var bullet_collision_info = move_and_collide(velocity)
	
	velocity.y += gravity
	
	if bullet_collision_info != null:
		self.queue_free()
		if bullet_collision_info.collider.name == "PixelatedBoss":
			bullet_collision_info.collider.on_Knockback_event()
		if bullet_collision_info.collider.name.begins_with("Enemy1Body"):
			bullet_collision_info.collider.die()
		if bullet_collision_info.collider.name.begins_with("Enemy2Body"):
			bullet_collision_info.collider.die()
	
	speed += speed_scaling_amount
	
	if has_been_fired == false:
		velocity = (get_parent().get_node("Player_Body").velocity / 50 # May need to dampen this value a little bit more if it seems too intense
		 + Vector2(get_global_mouse_position()
		 - player_body.position).normalized() * speed)
		
		has_been_fired = true
