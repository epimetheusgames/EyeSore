extends Node2D


func _process(delta):
	$RichTextLabel.rect_position.y -= 0.4

	if Input.is_action_just_pressed("ui_pause"):
		get_parent().Open_Main_Menu(self)
