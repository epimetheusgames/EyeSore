extends Node2D


func _ready():
	add_to_group("buttons")

func _on_Area2D_area_entered(area):
	if $AnimatedSprite.animation == "Unpressed":
		$AnimatedSprite.animation = "Pressing"
		$AnimatedSprite.play()
