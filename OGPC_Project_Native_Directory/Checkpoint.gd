extends Node2D


func _on_Area2D_area_entered(area):
	if area.name == "Player_Bullet_Body":
		$AnimatedSprite.animation = "Activated"

func _on_Area2D_body_entered(body):
	print(body.name)
	if body.name == "Player_Bullet_Body" or body.name == "Player_Shockwave_Bullet":
		get_parent().save_checkpoint(position)
		get_parent().save_game()
		$AnimatedSprite.animation = "Activated"
