extends KinematicBody2D


const normal_bullet_file_path = preload("res://Player_Bullet.tscn")
const shockwave_bullet_file_path = preload("res://Player_Shockwave_Bullet.tscn")
const death_particles_file_path = preload("res://Player_Death_Animation_Particles.tscn")

var paused = false

var player_health = clamp(36, 4, 36)

var death_particles

var camera_pos

var land_sfx_cooldown = false

var knockback_direction = 0
export var shockwave_knockback_strength = Vector2(480, 410)
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
var respawn_position = Vector2(0, 0)

var player_direction = "right"

var self_position = self.position

# the direction that the player is currently requesting to shoot in, can be any of the cardinal directions or diagonals
export var shoot_direction = "null"
# the type of bullet to shoot
export var bullet_type = 0

var shockwave_bullet_cooldown_timer = 0

var last_grounded_pos = Vector2(0, 0)
# Time that you have to be on the ground before your ground pos is resetted
export var ground_reset_countdown = 60
var max_ground_reset_time = ground_reset_countdown

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
export var jump_force = 290
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

var start_position = respawn_position

func _ready():
	self.show()
	$Death_Anim_Transition.stop_anim()
	respawn_position = position
	print("player" + str(start_position))

# anything that needs to be in a consistent update cycle goes here
func _physics_process(delta):
	if paused:
		return
	
	# get a float between -1 and 1 of the amount that the player is trying to move in each direction, this is especially nice for controllers becauyse the joysticks can sense a value of how far they are being pushed instead of a keyboard which is just pressed or not pressed, so this allows controller players to move a smaller amount when they move their joystick less, negativenumbers are left, positive are right
	input.x = Input.get_action_strength("movement_right") - Input.get_action_strength("movement_left")
	
	if input.x > 0:
		player_direction = "right"
	elif input.x < 0:
		player_direction = "left"
	
	#if no input is currently being registered, apply friction to slow down the player, and if an input is currently being registered, apply the acceleration for the input
	if input.x == 0 or $Death_Animation_Timer.time_left > 0:
		Apply_Friction()
	else:
		Apply_Acceleration(input.x)
	
	# if player is touching ground set ground buffer to max
	if is_on_floor():
		ground_buffer = 10
	
	# if the player is pressing jump and the player is on the ground, jump, and if the player releases the jump button before the apex of the jump, start decelerating the player's y speed by the low_jump_deceleration_speed variable
	
	if $Death_Animation_Timer.time_left == 0:
		if Input.is_action_just_pressed("movement_jump") and ground_buffer > 0:
			# play jump SFX
			get_node("/root/MainMenuRootNode/Jump_SFX_Player").play()
			# apply upwards velocity to jump
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
	
	# don't apply gravity if the player is dead, that way the camera stays in place
	if $Death_Animation_Timer.time_left == 0:
		# if the bool fastfall is true, if the player's y velocity is less than the max fall speed * 1.5 apply gravity, this is because if the player is fastfalling we need to increase the max fall speed to allow that. if the player is not fastfalling, we do the same thing but with just the normal max fall speed
		if fastfall == true:
			if velocity.y < max_fall_speed * 1.5:
				Apply_Gravity()
		else:
			if velocity.y < max_fall_speed:
				Apply_Gravity()
	
	# if the player is below a certain y level, aka below the map, reset the scene (this is a way to kill the player, there are better ways but they take more time)
	if position.y > 10000:
		# TODO: Reset enemy positions
		get_parent().get_parent().get_parent().Play_OWIE_Player()
		position = respawn_position
		player_health -= 3
		
	if Input.is_action_just_pressed("self_destruct"):
		get_node("/root/MainMenuRootNode/Player_Hurt_Player").play()
		
		position = respawn_position
	
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
	elif not is_on_floor() and player_direction == "right":
		$AnimatedSprite.animation = "Jumping_Right"
		$AnimatedSprite.play()
	elif not is_on_floor() and player_direction == "left":
		$AnimatedSprite.animation = "Jumping_Left"
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	if is_on_floor() and ground_reset_countdown <= 0 and not $Death_Animation_Timer.time_left > 0:
		ground_reset_countdown = max_ground_reset_time
		last_grounded_pos = self.position
	elif is_on_floor():
		# this piece of somewhat random code is meant to be run once every time the player touches the ground, and it plays the SFX for landing on the ground
		if land_sfx_cooldown == false:
			get_node("/root/MainMenuRootNode/Land_SFX_Player").play()
			land_sfx_cooldown = true
		# Count down ground reset countdown
		ground_reset_countdown -= 1
	elif not is_on_floor():
		land_sfx_cooldown = false
	
	# Just so it doesn't reset right if they touch the ground somewhere dangerous
	# if the countdown has been at a low number because it didn't reset after they
	# jumped off the previous platform.
	if not is_on_floor():
		ground_reset_countdown = max_ground_reset_time
	
	ground_buffer -= 1
	
	shockwave_bullet_cooldown_timer -= 1


#anything that doesn't need to be in a consistent update cycle goes here
func _process(delta):
	if paused:
		return
	
	self_position = self.position
	
	if Input.is_action_just_pressed("Shoot_Normal_Bullet"):
		bullet_type = 0
		Shoot_Bullet(bullet_type)
	elif Input.is_action_just_pressed("Shoot_Shockwave_Bullet") and shockwave_bullet_cooldown_timer <= 0:
		bullet_type = 1
		Shoot_Bullet(bullet_type)
		
		shockwave_bullet_cooldown_timer = 45
	
	$Player_Gun_Base.look_at(get_global_mouse_position())
	
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
	
	$Player_Gun_Base.rotation_degrees = int(shoot_direction)
	
	#if bullet_type == 0:
	#	var player_normal_bullet = normal_bullet_file_path.instance()
	#	
	#	get_node("/root/MainMenuRootNode/Shooting_SFX_Player").play()
	#	
	#	get_parent().add_child(player_normal_bullet)
	#	
	#	player_normal_bullet.position = $Player_Gun_Base/Player_Bullet_Position.global_position
	if bullet_type == 1:
		var player_shockwave_bullet = shockwave_bullet_file_path.instance()
		
		get_node("/root/MainMenuRootNode/Shockwave_Shooting_SFX_Player").play()
		
		get_parent().add_child(player_shockwave_bullet)
		
		player_shockwave_bullet.position = $Player_Gun_Base/Player_Bullet_Position.global_position

func Apply_Health_Sprites(player_health):
	get_node("ProgressBar").value = player_health

func Apply_Shockwave_Knockback(self_position, player_shockwave_bullet_node):
	# this should be able to return a force vector that can be added to the player's velocity to propel them away from the shockwave
	knockback_direction = (self_position - player_shockwave_bullet_node.position).normalized()
	knockback_force = shockwave_knockback_strength * knockback_direction
	
	velocity = knockback_force

func Shockwave_Hit_Player(player_shockwave_bullet_node_self):
	var player_shockwave_bullet_node = player_shockwave_bullet_node_self
	$Shockwave_Boost_Particles.emitting = true
	Apply_Shockwave_Knockback(self_position, player_shockwave_bullet_node)

func _on_Area2D_body_entered(body):
	# check if body is spikes and the player is not already dead
	if "Spikes" in body.name and $Death_Animation_Timer.time_left <= 0:
		var coords = get_spike_coords(body)
		manage_wires(coords, body, get_parent().get_node("TileMap"))
		# start the timer for respawn to allow the death animation to play
		$Death_Animation_Timer.start(1)
		# play the death sfx and hide the player to replace it with the death particles
		get_node("/root/MainMenuRootNode/Player_Hurt_Player").play()
		# spawn the player's death particles (just four quadrants of the player that split away from each other when spawned)
		var death_particles = death_particles_file_path.instance()
		$Death_Anim_Transition.play_anim()
		$AnimatedSprite.hide()
		death_particles.position = self.position
		get_parent().add_child(death_particles)
		
func force_death():
	position = start_position 

func _on_Death_Animation_Timer_timeout():
	$AnimatedSprite.show()
	position = respawn_position
	$Death_Animation_Timer.stop()
	$Death_Anim_Transition.stop_anim()
	
func get_spike_coords(spike_tileset):
	var tile_coords = spike_tileset.world_to_map(position)
	var offsets = [[0, -1], [0, 1], [1, 0], [-1, 0], [-1, -1], [1, 1], [0, 0]]
	
	for offset in offsets:
		var offset_coords = [tile_coords.x + offset[0], tile_coords.y + offset[1]]
		if is_tile_at(offset_coords, spike_tileset):
			return Vector2(offset_coords[0], offset_coords[1])
			
func pause():
	paused = true 
	
func unpause():
	paused = false
	
func is_tile_at(pos, tileset):
	if tileset.get_cell(pos[0], pos[1]) != -1:
		return true
	return false 
	
func manage_wires(death_pos_on_tileset, tileset, grass_tileset):
	var wires = get_tree().get_nodes_in_group("wires")
	
	for wire in wires:
		if wire.get_tileset_coords(1, tileset) == death_pos_on_tileset:
			var touching_checkpoint = wire.get_touching_checkpoint(0)
			
			if touching_checkpoint:
				touching_checkpoint.save_checkpoint()
			
			else:
				wire.delete_tile_at(0, grass_tileset, true, get_parent().get_parent().deleted_spikes, get_parent().get_parent().deleted_spike_types)
