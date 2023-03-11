extends KinematicBody2D


var velocity = Vector2.ZERO
export var gravity_strength = 10
export var friction_strength = 20


func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2.UP)

func Apply_Gravity():
	velocity.y += gravity_strength

func Apply_Friction():
	velocity.x = move_toward(velocity.x, 0, friction_strength)
