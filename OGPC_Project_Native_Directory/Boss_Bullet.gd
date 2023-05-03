extends KinematicBody2D

var velocity = Vector2(0, 0)
var collision_data


func _ready():
	pass

func _physics_process(delta):
	velocity.x += -0.07
	
	collision_data = move_and_collide(velocity)
	
	if "KinematicCollision2D" in str(collision_data):
		self.queue_free()


