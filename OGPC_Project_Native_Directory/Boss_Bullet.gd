extends KinematicBody2D

var velocity = Vector2(0, 0)


func _ready():
	pass

func _physics_process(delta):
	velocity.x += -0.07
	
	move_and_collide(velocity)


