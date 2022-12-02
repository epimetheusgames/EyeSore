extends KinematicBody2D


var collapse = false
var velocity = Vector2.ZERO

export var gravity_strength = 10


func _physics_process(delta):
	var player = get_parent().get_node("Player_Body")
	$CollisionShape2D.disabled = false
	var collision_info = move_and_collide(velocity)
	$CollisionShape2D.disabled = true
	
	if collapse:
		collapse = true
		Apply_Gravity()
		
	#var contacts = $CollisionShape2D.shape.collide_and_get_contacts($CollisionShape2D.transform, player.get_node("CollisionShape2D").shape, player.transform)
	
	if collision_info != null:
		collapse = true

func Apply_Gravity():
	velocity.y += gravity_strength
