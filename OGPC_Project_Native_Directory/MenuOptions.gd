extends Node2D

var selected = 1
var prev_selected = 1

func _process(delta):
	if Input.is_action_just_pressed("Just_Arrowkey_Down"):
		if selected < 4:
			selected += 1
	if Input.is_action_just_pressed("Just_Arrowkey_Up"):
		if selected > 1:
			selected -= 1
			
	if prev_selected != selected:
		get_parent().Play_Click_SFX()
			
	if selected == 1:
		$Label.modulate = Color(2.75, 2.75, 2.75, 1)
		$Label2.modulate = Color(1, 1, 1, 1)
	if selected == 2:
		$Label2.modulate = Color(2.75, 2.75, 2.75, 1) 
		$Label.modulate = Color(1, 1, 1, 1)
		$Label3.modulate = Color(1, 1, 1, 1)
	if selected == 3:
		$Label3.modulate = Color(2.75, 2.75, 2.75, 1) 
		$Label2.modulate = Color(1, 1, 1, 1)
		$Label4.modulate = Color(1, 1, 1, 1)
	if selected == 4:
		$Label3.modulate = Color(1, 1, 1, 1)
		$Label4.modulate = Color(2.75, 2.75, 2.75, 1)
	
	if Input.is_action_just_pressed("ui_accept"):
		get_parent().Play_Click_SFX()
		buttons_pressed()
	
	prev_selected = selected

func buttons_pressed():
	if selected == 1:
		var data = $Load_Functionality.get_game_data()
		var level_path = get_parent().level_names[$Load_Functionality.data["level"]]
		var level = load(level_path).instance()
		level.set_player_spawnpoint_and_position(data[1], data[2], data[3], data[7], data[8], data[9])
		get_parent().Play_Grass_Area_Music()
		$Load_Functionality.set_keybinds(data[4], data[4]) 
		get_parent().Open_Other(self, level, true)
	if selected == 2:
		get_parent().Open_Level_Select_Menu(self)
	if selected == 3:
		get_parent().Open_Options_Menu(self)
	if selected == 4:
		get_tree().quit()

func _on_PlayButton_button_up():
	selected = 1
	buttons_pressed()
	
func _on_LevelSelectButton_button_up():
	selected = 2
	buttons_pressed()
	
func _on_OptionsButton_button_up():
	selected = 3
	buttons_pressed()

func _on_QuitButton_button_up():
	selected = 4
	buttons_pressed()

