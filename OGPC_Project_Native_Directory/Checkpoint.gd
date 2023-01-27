extends Node2D


func _on_Area2D_area_entered(area):
	if area.name == "Player_Body":
		save_checkpoint()

func _on_Area2D_body_entered(body):
	if body.name == "Player_Bullet_Body" or body.name == "Player_Shockwave_Bullet" or body.name == "Player_Body":
		save_checkpoint()
		
func save_checkpoint():
	get_parent().save_checkpoint(position)
	get_parent().save_game()
	
	if not $AnimatedSprite.animation == "Activated":
		$AudioStreamPlayer.play()
	
	$AnimatedSprite.animation = "Activated"
