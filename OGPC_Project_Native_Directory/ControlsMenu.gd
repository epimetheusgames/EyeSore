extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
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
	$Left.keybind = keybinds["left"]
	$Right.keybind = keybinds["right"]
	$Jump.keybind = keybinds["jump"]
	$Shockwave.keybind = keybinds["shockwave"]
	$Bullet.keybind = keybinds["bullet"] 
