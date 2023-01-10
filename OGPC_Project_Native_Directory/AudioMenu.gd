extends Node2D

var selected = 0
var prev_selected = 0
onready var options = [$Label2]


func _ready():
	var data = $SaveFunctionality.get_game_data()
	$Music.set_value(data[5])
	$SFX.set_value(data[6])
	print('hi')

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
		get_parent().Play_Click_SFX()
		if selected == 0:
			$SaveFunctionality.save_audio($Music.get_value(), $SFX.get_value())
			print($SaveFunctionality.data["keybinds"]["music-audio"])
			$SaveFunctionality.save_game()
			get_parent().Open_Options_Menu(self)
			
	set_bus_volume(1, $Music.get_value()/100)
	set_bus_volume(2, $SFX.get_value()/100)
	
	prev_selected = selected

func set_bus_volume(bus_index, value):
	AudioServer.set_bus_volume_db(bus_index, linear2db(value))
	AudioServer.set_bus_mute(bus_index, value < 0.01)
