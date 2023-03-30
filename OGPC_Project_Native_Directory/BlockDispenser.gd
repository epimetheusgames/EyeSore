extends Area2D

var original_pos = null

func _ready():
	original_pos = $MoveableBlockBody.global_position

func _on_ButtonPressArea_body_entered(body):
	if "Player_Body" in body.name:
		$MoveableBlockBody.set_telepoint(original_pos)
		$AnimatedSprite.animation = "Pressed"


func _on_ButtonPressArea_body_exited(body):
	if "Player_Body" in body.name:
		$AnimatedSprite.animation = "Unpressed"
