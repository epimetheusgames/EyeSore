extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and not $Left.selected and not $Right.selected and not $Jump.selected and not $Terminal.selected and not $Respawn.selected:
		exit_menu()
	
func clear_all_except(node):
	for child in get_children():
		if child is Area2D:
			if not child.name == node.name:
				child.selected = false

func exit_menu():
	for i in range(2): # Okay I have no idea how this works but if I repeat it twice it sets the keybinds correctly but otherwise you have to restart to do it.
		$SaveFunctionality.save_keybinds(
			{
				"left-type": $Left.keybind_type, 
				"left": $Left.keybind, 
				"right-type": $Right.keybind_type, 
				"right": $Right.keybind, 
				"jump-type": $Jump.keybind_type, 
				"jump": $Jump.keybind,
				"terminal-type": $Terminal.keybind_type,
				"terminal": $Terminal.keybind, 
				"respawn-type": $Respawn.keybind_type,
				"respawn": $Respawn.keybind,
			}
		)
		$SaveFunctionality.set_keybinds($SaveFunctionality.get_game_data()[4])
		$SaveFunctionality.save_game()
	#get_tree().reload_current_scene()
	get_parent().Open_Options_Menu(self)

func _on_TextureButton_button_up():
	exit_menu()
