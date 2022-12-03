extends KinematicBody2D


var attacking = false
var was_attacking = false
var was_attacked = false
var velocity = Vector2.ZERO
var died = false
var decreasing_health = false 
var decreasing_health_progress = 0

var one_health_unit_in_image_scale
var attack_frames_length
var health_decreased_per_animation_frame

export var gravity_strength = 10
export var friction_strength = 20
export var health = 100 # Can be changed


func _ready():
	$AttackTimer.start()
	$AnimatedSprite.animation = "attacking"
	attack_frames_length = 4 #$AnimatedSprite.frames may have something but I can't find it, so I've hardcoded in the value for now.
	$AnimatedSprite.animation = "idle"
	one_health_unit_in_image_scale = $Healthbar_Health.scale.x / health
	health_decreased_per_animation_frame = 0.1

func _physics_process(delta):
	Apply_Gravity()
	Apply_Friction()
	
	$Healthbar_Health.scale.x = one_health_unit_in_image_scale * health
	$Health_Text.text = str(int(health))
		
	if decreasing_health:
		if health <= 0:
			died = true
		health -= health_decreased_per_animation_frame
		decreasing_health_progress += health_decreased_per_animation_frame
		if decreasing_health_progress >= 1:
			decreasing_health_progress = 0
			decreasing_health = false
			
	if died:
		$Healthbar_Health.scale.x = one_health_unit_in_image_scale
		$CollisionPolygon2D.disabled = true
		$AnimatedSprite.visible = false 
		$Healthbar_Damage.visible = false 
		$Healthbar_Health.visible = false
		
	if was_attacked:
		was_attacked = false
		velocity = Vector2(100, -30)
	
	if attacking:
		$AnimatedSprite.animation = "attacking"
		$AnimatedSprite.play() 
	else:
		$AnimatedSprite.animation = "idle"
		$AnimatedSprite.play()
	
	if not attacking and was_attacking:
		$AttackTimer.start()
		
	if $AnimatedSprite.frame == attack_frames_length:
		attacking = false
		
	velocity = move_and_slide(velocity, Vector2.UP)
		
	var was_attacking = attacking
	
func Apply_Gravity():
	velocity.y += gravity_strength
	
func Apply_Friction():
	velocity.x = move_toward(velocity.x, 0, friction_strength)

func _on_AttackTimer_timeout():
	attacking = true
	
# In the future this will be and connection from the player bullet when it damages the enemy.
func on_Knockback_event():
	#$AnimatedSprite.animation = "damaged"
	decreasing_health = true
	attacking = false
	was_attacked = true 
 
