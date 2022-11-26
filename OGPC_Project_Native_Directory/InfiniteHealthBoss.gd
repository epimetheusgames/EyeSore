extends KinematicBody2D


var attacking = false
var was_attacking = false
var was_attacked = false
var velocity = Vector2.ZERO

var attack_frames_length

export var gravity_strength = 10
export var friction_strength = 20


func _ready():
	$AttackTimer.start()
	attack_frames_length = len($AnimatedSprite.frames.frames)

func _physics_process(delta):
	Apply_Gravity()
	Apply_Friction()
	
	if self.was_attacked:
		velocity += Vector2(10, -5)
	
	if attacking:
		$AnimatedSprite.animation = "attacking"
		$AnimatedSprite.play() 
	else:
		$AnimatedSprite.animation = "idle"
		$AnimatedSprite.play()
	
	if not attacking and was_attacking:
		$AttackTimer.start()
		
	if $AnimatedSprite.frame == attack_frames_length + 2:
		attacking = false
		
	position += velocity * delta
		
	var was_attacking = attacking
	
func Apply_Gravity():
	velocity.y += gravity_strength
	
func Apply_Friction():
	velocity.x = move_toward(velocity.x, 0, friction_strength)

func _on_AttackTimer_timeout():
	attacking = true
	
# In the future this will be and connection from the player bullet when it damages the enemy.
func on_knockback_event():
	$AnimatedSprite.animation = "damaged"
	attacking = false
	was_attacked = true 
 
