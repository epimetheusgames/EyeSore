extends Node2D


var selected = 1

func _ready():
	var data = $Save_Functionality.get_game_data()
	
	$SpinBox.max_value = data[0] + 1
	$SpinBox.value = data[0] + 1
	
func _process(delta):
	if ($PlayButton.pressed or Input.is_action_just_pressed("ui_accept")) and selected == 1:
		get_parent().Play_Click_SFX()
		var data = $Save_Functionality.get_game_data()
		var level_path = get_parent().level_names[$SpinBox.value - 1]
		var level = load(level_path).instance()
		level.set_player_spawnpoint_and_position(data[1], data[2], data[3], data[7], data[8], data[9])
		level.temp_current_level = int($SpinBox.value - 1)
		get_parent().Play_Grass_Area_Music()
		$Save_Functionality.set_keybinds(data[4], data[4]) 
		get_parent().Open_Other(self, level, true)
	elif ($BackButton.pressed or Input.is_action_just_pressed("ui_accept")) and selected == 2:
		get_parent().Play_Click_SFX()
		get_parent().Open_Main_Menu(self)
		
	if Input.is_action_just_pressed("Just_Arrowkey_Down"):
		$Label3.modulate = Color(2.75, 2.75, 2.75, 1)
		$Label.modulate = Color(1, 1, 1, 1)
		selected = 2
	if Input.is_action_just_pressed("Just_Arrowkey_Up"):
		$Label.modulate = Color(2.75, 2.75, 2.75, 1)
		$Label3.modulate = Color(1, 1, 1, 1)
		selected = 1

func _on_BackButton_button_down():
	selected = 2

func _on_PlayButton_button_down():
	selected = 1
