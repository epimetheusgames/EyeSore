extends Area2D

export var text_keybind = ""
onready var keybind_type = get_parent().get_node("SaveFunctionality").data["keybinds"][name.to_lower() + "-type"]
onready var keybind = get_parent().get_node("SaveFunctionality").data["keybinds"][name.to_lower()]
var selected = false
var unselect_next_frame = false

func _input(event):
	if event is InputEventKey and selected:
		keybind = event.get_scancode()
		text_keybind = OS.get_scancode_string(event.unicode)
		unselect_next_frame = true
		keybind_type = 0
	if event is InputEventJoypadButton and selected:
		keybind_type = 1
		keybind = event.button_index
		text_keybind = ""
		unselect_next_frame = true
		
func _ready():
	text_keybind = OS.get_scancode_string(keybind)
		
func _process(delta):
	if unselect_next_frame:
		unselect_next_frame = false 
		selected = false
	
	$Keybind_Text.text = text_keybind
	
	if selected:
		$OgpcMainMenuKeybindSelector.visible = false 
		$OgpcMainMenuKeybindSelectorSelected.visible = true 
	else:
		$OgpcMainMenuKeybindSelector.visible = true
		$OgpcMainMenuKeybindSelectorSelected.visible = false

func _on_TextureButton_button_up():
	if get_tree().root.get_child(0) != self:
		get_parent().clear_all_except(self)
	selected = not selected
