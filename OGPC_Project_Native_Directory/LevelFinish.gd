extends Node2D


func _ready():
	add_to_group("levelfinishers")

func _on_Area2D_area_entered(area):
	# if the player touches the checkpoint, save.
	if area.name == "Player_Body":
		save_level()

func _on_Area2D_body_entered(body):
	if body.name == "Player_Body":
		save_level()
		
func save_level():
	get_parent().next_level()
