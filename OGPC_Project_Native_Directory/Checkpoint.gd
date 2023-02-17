extends Node2D

func _ready():
	add_to_group("checkpoints")

func _on_Area2D_area_entered(area):
	# if the player touches the checkpoint, save.
	if area.name == "Player_Body":
		save_checkpoint()

func _on_Area2D_body_entered(body):
	if body.name == "Player_Body":
		save_checkpoint()
		
func save_checkpoint():
	# Actually write to the file using Save Functionality node.
	get_parent().save_checkpoint(position)
	get_parent().data = get_parent().get_current_level_data(get_parent().data["level"])
	get_parent().save_game()
	
	# Using the animation as a boolian I know so great right?
	if not $AnimatedSprite.animation == "Activated":
		# Play that sattisfying sfx.
		$AudioStreamPlayer.play()
	
	# Activate that boolian/animation more efficient I guess? Not really lol.
	$AnimatedSprite.animation = "Activated"

func is_point_inside(point):
	var rect = Rect2(to_global($ReferenceRect.rect_position), $ReferenceRect.rect_size)
	
	print(rect.has_point(point))
	return rect.has_point(point)
