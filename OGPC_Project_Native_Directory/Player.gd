extends KinematicBody2D


const normal_bullet_file_path = preload("res://Player_Bullet.tscn")
const shockwave_bullet_file_path = preload("res://Player_Shockwave_Bullet.tscn")

var player_health = clamp(29, 3, 29)

var knockback_direction = 0
export var shockwave_knockback_strength = Vector2(600, 400)
var knockback_force = 0

# the Vector2 for the player's velocity
var velocity = Vector2.ZERO
# the Vector2 for the player's input, ranging from 1 (right) to -1 (left)
var input = Vector2.ZERO

# the players current speed, it's the same as velocity.x but if it's negative it converts it to a positive, this is used for calculations
var current_speed = 0

# whether or not the player is currently holding down to fastfall
var fastfall = false

# the Vector2 that holds the player's current respawn position, this is updated when the player touches a checkpoint
var respawn_position = Vector2(96, 236)

var player_direction = "right"

var self_position = self.position

# the direction that the player is currently requesting to shoot in, can be any of the cardinal directions or diagonals
export var shoot_direction = "null"
# the type of bullet to shoot
export var bullet_type = 0

signal boss_hit

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
# the upward force of the player's jump
export var jump_force = 280
# the speed at which the player's y velocity starts decelerating after they let go of the jump button
export var low_jump_deceleration_speed = 1.95
# the player's maximum speed
export var max_speed = 200
# the max falling speed of the player
export var max_fall_speed = 260
# the speed at which the player switches directions slower
export var fast_turnaround_threshold = 180
# the buffer for leaving the ground and still jumping
export var ground_buffer = 6


# anything that needs to be in a consistent update cycle goes here
func _physics_process(delta):
	# get a float between -1 and 1 of the amount that the player is trying to move in each direction, this is especially nice for controllers becauyse the joysticks can sense a value of how far they are being pushed instead of a keyboard which is just pressed or not pressed, so this allows controller players to move a smaller amount when they move their joystick less, negativenumbers are left, positive are right
	input.x = Input.get_action_strength("movement_right") - Input.get_action_strength("movement_left")
	
	if input.x > 0:
		player_direction = "right"
	elif input.x < 0:
		player_direction = "left"
	
	#if no input is currently being registered, apply friction to slow down the player, and if an input is currently being registered, apply the acceleration for the input
	if input.x == 0:
		Apply_Friction()
	else:
		Apply_Acceleration(input.x)
	
	# if player is touching ground set ground buffer to max
	if is_on_floor():
		ground_buffer = 10
	
	# if the player is pressing jump and the player is on the ground, jump, and if the player releases the jump button before the apex of the jump, start decelerating the player's y speed by the low_jump_deceleration_speed variable
	if Input.is_action_just_pressed("movement_jump") and ground_buffer > 0:
		velocity.y -= jump_force
	elif Input.is_action_just_released("movement_jump") and velocity.y < low_jump_deceleration_speed / 5:
		velocity.y /= low_jump_deceleration_speed
	
	# if the player is pressing the down button, set the bool fastfall to true, and if not, set it to false
	if Input.is_action_pressed("movement_down"):
		fastfall = true
	else:
		fastfall = false
	
	# this is the line that actually moves the player, is moves the player by the player's velocity, and the Vector2.UP part makes it so that the game can detect when the player is on a wall, floor, or ceiling
	velocity = move_and_slide(velocity, Vector2.UP)
	
	# set the current speed variable to velocity.x if the velocity.x is positive, and if it is negative set the current speed variable to the velocity.x converted to a positive by multiplying it by -1
	if velocity.x >= 0:
		current_speed = velocity.x
	elif velocity.x < 0:
		current_speed = velocity.x * -1
	
	# if the bool fastfall is true, if the player's y velocity is less than the max fall speed * 1.5 apply gravity, this is because if the player is fastfalling we need to increase the max fall speed to allow that. if the player is not fastfalling, we do the same thing but with just the normal max fall speed
	if fastfall == true:
		if velocity.y < max_fall_speed * 1.5:
			Apply_Gravity()
	else:
		if velocity.y < max_fall_speed:
			Apply_Gravity()
	
	# if the player is below a certain y level, aka below the map, reset the scene (this is a way to kill the player, there are better ways but they take more time)
	if position.y > 700:
		# TODO: Reset enemy positions
		position = respawn_position
		player_health -= 3
		
	if Input.is_action_just_pressed("self_destruct"):
		# TODO: Reset enemy positions
		position = respawn_position
		
		# lower player health upon falling out of world
		player_health -= 1
	
	# if the player is not moving, start the animation player and play the idle animation, and the rest of the animations have not been implemented yet so if it needs to play those it just stops the animation
	if velocity.x == 0 and is_on_floor() and player_direction == "left":
		$AnimatedSprite.animation = "Idle_Left"
	elif velocity.x == 0 and is_on_floor() and player_direction == "right":
		$AnimatedSprite.animation = "Idle_Right"
	elif velocity.x > 0 and is_on_floor():
		#set animation to walking right
		$AnimatedSprite.animation = "Walking_Right"
		$AnimatedSprite.play()
	elif velocity.x < 0 and is_on_floor():
		#set animation to walking left
		$AnimatedSprite.animation = "Walking_Left"
		$AnimatedSprite.play()
	elif not is_on_floor() and input.x == 0:
		$AnimatedSprite.animation = "Jumping_Center"
		$AnimatedSprite.play()
	elif not is_on_floor() and velocity.x > 0:
		$AnimatedSprite.animation = "Jumping_Right"
		$AnimatedSprite.play()
	elif not is_on_floor() and velocity.x < 0:
		$AnimatedSprite.animation = "Jumping_Left"
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	ground_buffer -= 1


#anything that doesn't need to be in a consistent update cycle will go here
func _process(delta):
	self_position = self.position
	
	if Input.is_action_just_pressed("Shoot_Normal_Bullet"):
		bullet_type = 0
		Shoot_Bullet(bullet_type)
	elif Input.is_action_just_pressed("Shoot_Shockwave_Bullet"):
		bullet_type = 1
		Shoot_Bullet(bullet_type)
	
	Apply_Health_Sprites(player_health)

# if fastfall is false, increase the player's y velocity by the normal gravity strength, and if it is true, increase the player's y velocity by the fastfalling gravity strength
func Apply_Gravity():
	if fastfall == true:
		velocity.y += fastfall_gravity_strength
	else:
		velocity.y += gravity_strength

# if the player's velocity is less than the fast_turnaround_threshold variable, move the player's x velocity towards a higher speed in whatever direction the player is facing by the acceleration speed, but with double the turnaround speed, but if it is more than the fast_turnaround_threshold variable, then do the same thing but with the normal turnaround speed
func Apply_Acceleration(x_input):
	if current_speed < fast_turnaround_threshold:
		acceleration_speed = 10
		turnaround_speed = 24
	else:
		acceleration_speed = 10
		turnaround_speed = 18
	
	if input.x * velocity.x >= 0:
		velocity.x = move_toward(velocity.x, x_input * max_speed, acceleration_speed)
	else:
		velocity.x = move_toward(velocity.x, x_input * max_speed, turnaround_speed)

#move the player's x velocity towards 0 by the friction_strength variable every time it is called
func Apply_Friction():
	velocity.x = move_toward(velocity.x, 0, friction_strength)

func Shoot_Bullet(bullet_type):
	
	if Input.is_action_pressed("movement_right") and Input.is_action_pressed("movement_up"):
		shoot_direction = 45
	elif Input.is_action_pressed("movement_left") and Input.is_action_pressed("movement_up"):
		shoot_direction = -45
	elif Input.is_action_pressed("movement_right") and Input.is_action_pressed("movement_down"):
		shoot_direction = 135
	elif Input.is_action_pressed("movement_left") and Input.is_action_pressed("movement_down"):
		shoot_direction = -135
	elif Input.is_action_pressed("movement_right") and not Input.is_action_pressed("movement_up") and not Input.is_action_pressed("movement_down"):
		shoot_direction = 90
	elif Input.is_action_pressed("movement_left") and not Input.is_action_pressed("movement_up") and not Input.is_action_pressed("movement_down"):
		shoot_direction = -90
	elif Input.is_action_pressed("movement_up") and not Input.is_action_pressed("movement_right") and not Input.is_action_pressed("movement_left") and not Input.is_action_pressed("movement_down"):
		shoot_direction = 0
	elif Input.is_action_pressed("movement_down") and not Input.is_action_pressed("movement_right") and not Input.is_action_pressed("movement_left") and not Input.is_action_pressed("movement_up"):
		shoot_direction = 180
	else:
		shoot_direction = 0
	
	$Player_Gun_Base.rotation_degrees = int(shoot_direction)
	
	if bullet_type == 0:
		var player_normal_bullet = normal_bullet_file_path.instance()
		
		$Shooting_SFX_Player.play()
		
		get_parent().add_child(player_normal_bullet)
		
		player_normal_bullet.position = $Player_Gun_Base/Player_Bullet_Position.global_position
	elif bullet_type == 1:
		var player_shockwave_bullet = shockwave_bullet_file_path.instance()
		
		$Shooting_SFX_Player.play()
		
		get_parent().add_child(player_shockwave_bullet)
		
		player_shockwave_bullet.position = $Player_Gun_Base/Player_Bullet_Position.global_position

func Apply_Health_Sprites(player_health):
	get_node("Camera2D/ProgressBar").value = player_health

func Apply_Shockwave_Knockback(self_position, player_shockwave_bullet_node):
	# this should be able to return a force vector that can be added to the player's velocity to propel them away from the shockwave
	knockback_direction = (self_position - player_shockwave_bullet_node.position).normalized()
	knockback_force = shockwave_knockback_strength * knockback_direction
	
	velocity = knockback_force

func Shockwave_Hit_Player(player_shockwave_bullet_node_self):
	var player_shockwave_bullet_node = player_shockwave_bullet_node_self
	Apply_Shockwave_Knockback(self_position, player_shockwave_bullet_node)
