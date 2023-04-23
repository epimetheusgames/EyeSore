extends Node2D


var display_other = false
var display_none = false

func _process(delta):
	if not display_other and get_parent().get_parent().is_wire_ui:
		$AnimatedSprite.visible = true
		$AnimatedSprite2.visible = false
	
	if display_other and get_parent().get_parent().is_wire_ui:
		$AnimatedSprite2.visible = true
		$AnimatedSprite.visible = false
	
	if display_none or not get_parent().get_parent().is_wire_ui:
		$AnimatedSprite.visible = false
		$AnimatedSprite2.visible = false

	if get_parent().get_parent().added_wire:
		display_other = true

	for wire in get_tree().get_nodes_in_group("wires"):
		if wire.really_placed_yet:
			display_none = true
