extends Node2D


func get_value():
	return $CanvasLayer/HSlider.value

func set_value(value):
	$CanvasLayer/HSlider.value = value
