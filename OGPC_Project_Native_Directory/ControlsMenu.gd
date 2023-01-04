extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and not $Left.selected and not $Right.selected and not $Jump.selected and not $Shockwave.selected and not $Bullet.selected:
		$SaveFunctionality.save_keybinds({"left": $Left.keybind, "right": $Right.keybind, "jump": $Jump.keybind, "shockwave": $Shockwave.keybind, "bullet": $Bullet.keybind})
		$SaveFunctionality.save_game()
		get_parent().Open_Options_Menu(self)
	
func clear_all_except(node):
	for child in get_children():
		if child is Area2D:
			if not child.name == node.name:
				child.selected = false

func _ready():
	var keybinds = $SaveFunctionality.get_file_data()["keybinds"]
	$Left.text_keybind = OS.get_scancode_string(keybinds["left"])
	$Right.text_keybind = OS.get_scancode_string(keybinds["right"])
	$Jump.text_keybind = OS.get_scancode_string(keybinds["jump"])
	$Shockwave.text_keybind = OS.get_scancode_string(keybinds["shockwave"])
	$Bullet.text_keybind = OS.get_scancode_string(keybinds["bullet"]) 
