extends Node2D


func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_parent().Open_Options_Menu(self)
	
	get_parent().Set_Screen_Brightness($Slider.get_value()/100)
