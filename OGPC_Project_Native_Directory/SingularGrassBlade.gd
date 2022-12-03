extends AnimatedSprite


var swayed_left = false 
var swaying_left = false 
var swaying_left2center = false
var swayed_right = false
var swaying_right = false
var swaying_right2center = false


func _ready():
	animation = "Idle"


func _process(delta):
	var player = get_parent().get_node("Player_Body") # In the future this will be get_parent().get_parent().get_node() because the singular blade will be part of a grass tile scene
	var player_id = player.get_instance_id()
	
	
	$KinematicBody2D/CollisionShape2D.disabled = false
	var collider = $KinematicBody2D.move_and_collide(Vector2.ZERO)
	$KinematicBody2D/CollisionShape2D.disabled = true
	
	print(swayed_left, swayed_right, swaying_left, swaying_right, swaying_left2center, swaying_right2center)
	
	if collider:
		if collider.collider_id == player_id:
			if not swaying_left and not swayed_left and player.position.x > $KinematicBody2D.position.x:
				animation = "Sway_Left"
				swaying_left = true 
			if not swaying_right and not swayed_right and player.position.x < $KinematicBody2D.position.x:
				animation = "Sway_Right"
				swaying_right = true 
	else:
		if swayed_left:
			animation = "Sway_Left_To_Center"
			swayed_left = false
			swaying_left2center = true 
		elif swayed_right:
			animation = "Sway_Right_To_Center"
			swayed_right = false
			swaying_right2center = true
	

func _on_SingularGrassBlade_animation_finished():
	if swaying_left:
		swaying_left = false
		swayed_left = true
		animation = "Left"
	elif swaying_right:
		swaying_left = false
		swayed_right = true
		animation = "Right"
	elif swaying_left2center:
		swaying_left2center = false
		animation = "Idle"
	elif swaying_right2center:
		swaying_right2center = false
		animation = "Idle"
