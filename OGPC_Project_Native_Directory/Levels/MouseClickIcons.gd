extends Node2D


func _process(delta):
	if get_parent().get_parent().is_wire_ui:
		$MouseLeftClick.visible = true
		$MouseRightClick.visible = true
	if not get_parent().get_parent().is_wire_ui:
		$MouseLeftClick.visible = false
		$MouseRightClick.visible = false
