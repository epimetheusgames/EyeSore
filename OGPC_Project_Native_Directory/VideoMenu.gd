extends Node2D


# Script responsible for managing the video menu (brightness, etc.)


func _ready():
	$Slider.set_value(100 - ($Save_Functionality.get_game_data()[4]["darkness"]*100))


func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_parent().Play_Click_SFX()
		$Save_Functionality.save_video(1 - $Slider.get_value()/100)
		$Save_Functionality.save_game()
		get_parent().Open_Options_Menu(self)
	
	get_parent().Set_Screen_Brightness(1 - $Slider.get_value()/100)


func _on_TextureButton_button_up():
	get_parent().Play_Click_SFX()
	$Save_Functionality.save_video(1 - $Slider.get_value()/100)
	$Save_Functionality.save_game()
	get_parent().Open_Options_Menu(self)
