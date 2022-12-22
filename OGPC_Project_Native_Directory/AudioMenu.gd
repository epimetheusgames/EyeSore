extends Node2D

var selected = 0
var prev_selected = 0
onready var options = [$Label2]

func _process(delta):
	for option in range(len(options)):
		if option == selected:
			options[option].modulate = Color(5, 5, 5, 1)
		else:
			print(options[option])
			options[option].modulate = Color(1, 1, 1, 1)
			
	if prev_selected != selected:
		get_parent().Play_Click_SFX()
		
	if Input.is_action_just_pressed("Just_Arrowkey_Down") and selected < len(options):
		selected += 1
	if Input.is_action_just_pressed("Just_Arrowkey_Up") and selected > 0:
		selected -= 1
		
	if Input.is_action_just_pressed("ui_accept"):
		get_parent().Play_Click_SFX()
		if selected == 0: # soon to be 4
			get_parent().Open_Options_Menu(self)
	
	prev_selected = selected
