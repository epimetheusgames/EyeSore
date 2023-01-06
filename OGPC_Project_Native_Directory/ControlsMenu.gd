extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and not $Left.selected and not $Right.selected and not $Jump.selected and not $Shockwave.selected and not $Bullet.selected:
		$SaveFunctionality.save_keybinds(
			{
				"left-type": $Left.keybind_type, 
				"left": $Left.keybind, 
				"right-type": $Right.keybind_type, 
				"right": $Right.keybind, 
				"jump-type": $Jump.keybind_type, 
				"jump": $Jump.keybind,
				"shockwave-type": $Shockwave.keybind_type,
				"shockwave": $Shockwave.keybind, 
				"bullet-type": $Bullet.keybind_type,
				"bullet": $Bullet.keybind,
			}
		)
		$SaveFunctionality.save_game()
		get_parent().Open_Options_Menu(self)
	
func clear_all_except(node):
	for child in get_children():
		if child is Area2D:
			if not child.name == node.name:
				child.selected = false
