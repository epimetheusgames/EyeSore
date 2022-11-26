extends KinematicBody2D


var velocity = Vector2(1, 0)
var speed = 150
var speed_scaling_amount = 20


func _physics_process(delta):
	
	var bullet_collision_info = move_and_collide(velocity.normalized() * delta * speed)
	
	if bullet_collision_info != null:
		self.queue_free()
	
	speed += speed_scaling_amount
	
	velocity = (Vector2.RIGHT * speed).rotated(get_node("/root/World_Root_Node/Player_Body/Player_Gun_Base").rotation_degrees) * delta
