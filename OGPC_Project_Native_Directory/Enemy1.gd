extends KinematicBody2D

# I did kind of copy a lot of this code from the player script

# whether or not the player is currently holding down to fastfall
var fastfall = false

# Enemy Vector2 velocity
var velocity = Vector2.ZERO 
# The direction the enemy will move in depending on calculations
var movement_direction = Vector2.ZERO
# I might need it
var current_speed = 0

# if enemy died
var died = false

#the strength of the player's gravity while not fastfalling
export var gravity_strength = 10
# the strength of the player's gravity while fastfalling
export var fastfall_gravity_strength = 25
# the speed of the player's acceleration
export var acceleration_speed = 5
# the speed of the player switching directions
export var turnaround_speed = 12
# the speed at which the player slows down
export var friction_strength = 20
# the speed at which the player's y velocity starts decelerating after they let go of the jump button
export var low_jump_deceleration_speed = 1.95
# the player's maximum speed
export var max_speed = 200
# the max falling speed of the player
export var max_fall_speed = 260
# the speed at which the player switches directions slower
export var fast_turnaround_threshold = 180

func _physics_process(delta):
	var player = get_owner().get_node("Player_Body")
	var space_state = get_world_2d().direct_space_state
	var self_position = position - $CollisionShape2D.shape.extents
	var result = space_state.intersect_ray(position, player.position, [self])
	
	if died:
		$AnimatedSprite.visible = false 
		$CollisionShape2D.disabled = true
		return
	
	movement_direction = Vector2.ZERO
	
	if result and result.collider.get_class() == "KinematicBody2D":
		if player.position.x < position.x:
			movement_direction.x = -1
		elif player.position.x > position.x:
			movement_direction.x = 1
			
	if movement_direction.x == 0:
		Apply_Friction()
	else:
		Apply_Acceleration(movement_direction.x)
		
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if velocity.x >= 0:
		current_speed = velocity.x
	elif velocity.x < 0:
		current_speed = velocity.x * -1
		
	if fastfall == true:
		if velocity.y < max_fall_speed * 1.5:
			Apply_Gravity()
	else:
		if velocity.y < max_fall_speed:
			Apply_Gravity()
			
	if position.y > 700:
		died = true
	
	if velocity.x == 0 and is_on_floor() and not result:
		if $AnimatedSprite.animation == "IdleLeft" or $AnimatedSprite.animation == "MadLeft":
			$AnimatedSprite.animation = "IdleLeft"
		elif $AnimatedSprite.animation == "IdleRight" or $AnimatedSprite.animation == "MadRight":
			$AnimatedSprite.animation = "IdleRight"
		$AnimatedSprite.play()
	elif velocity.x > 0 and is_on_floor():
		#set animation to walking right
		$AnimatedSprite.animation = "MadRight"
		$AnimatedSprite.play()
	elif velocity.x < 0 and is_on_floor():
		#set animation to walking left
		$AnimatedSprite.animation = "MadLeft"
		$AnimatedSprite.play()
	elif not is_on_floor() and movement_direction.x == 0:
		#$AnimatedSprite.animation = "Jumping_Center"
		$AnimatedSprite.play()
	elif not is_on_floor() and velocity.x > 0:
		#$AnimatedSprite.animation = "Jumping_Right"
		$AnimatedSprite.play()
	elif not is_on_floor() and velocity.x < 0:
		#$AnimatedSprite.animation = "Jumping_Left"
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

func Apply_Gravity():
	if fastfall == true:
		velocity.y += fastfall_gravity_strength
	else:
		velocity.y += gravity_strength
		
func Apply_Acceleration(x_direction):
	if current_speed < fast_turnaround_threshold:
		acceleration_speed = 10
		turnaround_speed = 24
	else:
		acceleration_speed = 10
		turnaround_speed = 18
	
	if movement_direction.x * velocity.x >= 0:
		velocity.x = move_toward(velocity.x, x_direction * max_speed, acceleration_speed)
	else:
		velocity.x = move_toward(velocity.x, x_direction * max_speed, turnaround_speed)

#move the player's x velocity towards 0 by the friction_strength variable every time it is called
func Apply_Friction():
	velocity.x = move_toward(velocity.x, 0, friction_strength)
