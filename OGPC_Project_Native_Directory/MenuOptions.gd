extends Node2D

var selected = 1
var prev_selected = 1

func _process(delta):
	if Input.is_action_just_pressed("Just_Arrowkey_Down"):
		if selected < 3:
			selected += 1
	if Input.is_action_just_pressed("Just_Arrowkey_Up"):
		if selected > 1:
			selected -= 1
			
	if prev_selected != selected:
		get_parent().Play_Click_SFX()
			
	if selected == 1:
		#$Label.text = "- Play -"
		$Label.modulate = Color(2.75, 2.75, 2.75, 1)
		#$Label2.text = "Options"
		$Label2.modulate = Color(1, 1, 1, 1)
	if selected == 2:
		#$Label2.text = "- Options -"
		$Label2.modulate = Color(2.75, 2.75, 2.75, 1) 
		#$Label.text = "Play"
		$Label.modulate = Color(1, 1, 1, 1)
		#$Label3.text = "Quit"
		$Label3.modulate = Color(1, 1, 1, 1)
	if selected == 3:
		#$Label2.text = "Options"
		$Label2.modulate = Color(1, 1, 1, 1)
		#$Label3.text = "- Quit -"
		$Label3.modulate = Color(2.75, 2.75, 2.75, 1)
	
	if Input.is_action_just_pressed("ui_accept"):
		get_parent().Play_Click_SFX()
		if selected == 1:
			var data = $Load_Functionality.get_game_data()
			var level_path = $Load_Functionality.levels[data[0]]
			var level = load(level_path).instance()
			level.set_player_spawnpoint_and_position(data[1], data[2], data[3])
			$Load_Functionality.set_keybinds(data[4]) # Change this when making save-unspecific keybinds
			get_parent().Open_Other(self, level, true)
		if selected == 2:
			get_parent().Open_Options_Menu(self)
		if selected == 3:
			get_tree().quit()
	
	prev_selected = selected
