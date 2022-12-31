extends Area2D

export var keybind = ""
var selected = false

func _input(event):
	if event is InputEventKey and selected:
		keybind = PoolByteArray([event.unicode]).get_string_from_utf8().capitalize()
		selected = false
		if event.unicode == 32:
			keybind = "SPACE"
	# Add edge cases for controllers
		
func _ready():
	connect("input_event", self, "_on_Area2D_input_event")
		
func _process(delta):
	$Keybind_Text.text = keybind
	
	if selected:
		$OgpcMainMenuKeybindSelector.visible = false 
		$OgpcMainMenuKeybindSelectorSelected.visible = true 
	else:
		$OgpcMainMenuKeybindSelector.visible = true
		$OgpcMainMenuKeybindSelectorSelected.visible = false

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"): # set this up in project settings
		if get_tree().root.get_child(0) != self:
			get_parent().clear_all_except(self)
		selected = not selected
