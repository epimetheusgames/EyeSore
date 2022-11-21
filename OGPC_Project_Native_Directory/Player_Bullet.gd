extends KinematicBody2D


var velocity = Vector2(1, 0)
var speed = 150
var speed_scaling_amount = 20


func _physics_process(delta):
	var enemies = get_tree().get_nodes_in_group("enemies")
	var bullet_collision_info = move_and_collide(velocity.normalized() * delta * speed)
	
	if bullet_collision_info != null:
		self.queue_free()
		for enemy in enemies:
			pass # check for if the bullet hit this specific enemy, if so, set enemy.died to true.
	
	speed += speed_scaling_amount
