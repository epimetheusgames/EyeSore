extends Node2D

var selected = 0
var prev_selected = 0
onready var options = [$Label2]

# Code for the audio menu, probably go and clean this up later.

func _ready():
	var data = $SaveFunctionality.get_game_data()
	$Music.set_value(data[5])
	$SFX.set_value(data[6])

func _process(delta):
	for option in range(len(options)):
		if option == selected:
			options[option].modulate = Color(5, 5, 5, 1)
		else:
			print(options[option])
			options[option].modulate = Color(1, 1, 1, 1)
			
	if prev_selected != selected:
		get_parent().Play_Click_SFX()
		
	if Input.is_action_just_pressed("ui_accept"):
		exit_menu()
			
	set_bus_volume(1, $Music.get_value()/100)
	set_bus_volume(2, $SFX.get_value()/100)
	
	prev_selected = selected

func set_bus_volume(bus_index, value):
	AudioServer.set_bus_volume_db(bus_index, linear2db(value))
	AudioServer.set_bus_mute(bus_index, value < 0.01)

func exit_menu():
	get_parent().Play_Click_SFX()
	if selected == 0:
		$SaveFunctionality.save_audio($Music.get_value(), $SFX.get_value())
		print($SaveFunctionality.data["keybinds"]["music-audio"])
		$SaveFunctionality.save_game()
		get_parent().Open_Options_Menu(self)


func _on_TextureButton_button_up():
	exit_menu()
