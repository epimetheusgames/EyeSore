extends Node2D

var selected = 0
var prev_selected = 0
var opened_ingame = false
onready var options = [$Label, $Label2, $Label3, $Label4, $Label5]

func _process(delta):
	for option in range(len(options)):
		if option == selected:
			options[option].modulate = Color(2.75, 2.75, 2.75, 1)
		else:
			options[option].modulate = Color(1, 1, 1, 1)
			
	if prev_selected != selected:
		get_parent().Play_Click_SFX()
		
	prev_selected = selected
		
	if Input.is_action_just_pressed("Just_Arrowkey_Down") and selected < 4:
		selected += 1
	if Input.is_action_just_pressed("Just_Arrowkey_Up") and selected > 0:
		selected -= 1
		
	if Input.is_action_just_pressed("ui_accept"):
		button_pressed()

func button_pressed():
	get_parent().Play_Click_SFX()
	if selected == 0:
		get_parent().Open_Audio_Menu(self)
	if selected == 1:
		get_parent().Open_Video_Menu(self)
	if selected == 2:
		get_parent().Open_Controls_Menu(self)
	if selected == 4:
		get_parent().Open_Main_Menu(self)

func _on_BackButton_button_up():
	selected = 4
	button_pressed()

func _on_AccesibilityButton_button_up():
	#selected = 4
	#button_pressed()
	pass # For now because accesibility is not implemented

func _on_ControlsButton_button_up():
	selected = 2
	button_pressed()

func _on_VideoButton_button_up():
	selected = 1
	button_pressed()

func _on_AudioButton_button_up():
	selected = 0
	button_pressed()
