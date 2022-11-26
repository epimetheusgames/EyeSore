extends KinematicBody2D


var attacking = false
var was_attacking = false
var attack_frames_length


func _ready():
	$AttackTimer.start()
	attack_frames_length = len($AnimatedSprite.frames.frames)

func _physics_process(delta):
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
		
	var was_attacking = attacking

func _on_AttackTimer_timeout():
	attacking = true
 
