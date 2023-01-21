extends Node2D


func _ready():
	$Slider.set_value($Save_Functionality.get_game_data()[4]["darkness"]*100)


func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		$Save_Functionality.save_video($Slider.get_value()/100)
		get_parent().Open_Options_Menu(self)
	
	get_parent().Set_Screen_Brightness($Slider.get_value()/100)


func _on_TextureButton_button_up():
	$Save_Functionality.save_video($Slider.get_value()/100)
	get_parent().Open_Options_Menu(self)
