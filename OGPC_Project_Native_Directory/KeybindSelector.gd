extends Area2D

# Beautiful code that makes some keybinds work.
export var text_keybind = ""
# This is working it's way through the specific dependant set of rules I have for the main menu.
# So basically the controls menu > save functionality node > data dict with all save data > keybinds
# dict for all keybinds save data > lowercasifying adding type to the end and boom that's the keybind's
# type so either 0/1, 0 for keyboard type, 1 for controller type.
onready var keybind_type = get_parent().get_node("SaveFunctionality").data["keybinds"][name.to_lower() + "-type"]
# Same thing as above but for the actual unicode (utf-8 for keys)
onready var keybind = get_parent().get_node("SaveFunctionality").data["keybinds"][name.to_lower()]
var selected = false
# Variable I put in for an edge case so there isn't an issue with it unselecting/not being selected.
var unselect_next_frame = false

func _input(event):
	# check for keyboard
	if event is InputEventKey and selected:
		keybind = event.get_scancode()
		text_keybind = OS.get_scancode_string(event.unicode).to_upper()
		
		if keybind == 16777231:
			text_keybind = "LEFT"
		if keybind == 16777232:
			text_keybind = "UP"
		if keybind == 16777233:
			text_keybind = "RIGHT"
		if keybind == 16777234:
			text_keybind = "DOWN"
		
		unselect_next_frame = true
		keybind_type = 0
	# check for controller
	if event is InputEventJoypadButton and selected:
		keybind_type = 1
		keybind = event.button_index
		text_keybind = ""
		unselect_next_frame = true
		
func _ready():
	# set text for unicode loaded in.
	text_keybind = OS.get_scancode_string(keybind)
		
func _process(delta):
	# do that unselect stuff.
	if unselect_next_frame:
		unselect_next_frame = false 
		selected = false
	
	$Keybind_Text.text = text_keybind
	
	# Sprite visuals, simple enough.
	if selected:
		$OgpcMainMenuKeybindSelector.visible = false 
		$OgpcMainMenuKeybindSelectorSelected.visible = true 
	else:
		$OgpcMainMenuKeybindSelector.visible = true
		$OgpcMainMenuKeybindSelectorSelected.visible = false

# Functionality for the texture button, which is a much better sollution than whatever peice of 
# crap I had earlier.
func _on_TextureButton_button_up():
	if get_tree().root.get_child(0) != self:
		get_parent().clear_all_except(self)
	selected = not selected
