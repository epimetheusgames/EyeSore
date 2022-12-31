extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_parent().Open_Options_Menu(self)
	
func clear_all_except(node):
	for child in get_children():
		if child is Area2D:
			if not child.name == node.name:
				child.selected = false
