extends Node2D

var selected = 1

func _process(delta):
	if Input.is_action_just_pressed("Just_Arrowkey_Down"):
		if selected < 3:
			selected += 1
	if Input.is_action_just_pressed("Just_Arrowkey_Up"):
		if selected > 1:
			selected -= 1
			
	if selected == 1:
		$Label.text = "- Play -"
		$Label2.text = "Options"
	if selected == 2:
		$Label2.text = "- Options -"
		$Label.text = "Play"
		$Label3.text = "Quit"
	if selected == 3:
		$Label2.text = "Options"
		$Label3.text = "- Quit -"
