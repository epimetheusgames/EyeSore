extends Node2D


func _ready():
	$HSlider.value = 0

func get_value():
	return $HSlider.value

func set_value(value):
	$HSlider.value = value

