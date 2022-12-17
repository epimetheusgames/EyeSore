extends Node2D

onready var MenuOptions = preload("res://MenuOptions.tscn")
onready var OptionsMenu = preload("res://OptionsMenu.tscn")
onready var AudioMenu = preload("res://AudioMenu.tscn")

func _ready():
	add_child(MenuOptions.instance())
	# Play Main Menu Audio
	
func Open_Options_Menu(closed_window):
	closed_window.queue_free()
	add_child(OptionsMenu.instance())

func Open_Audio_Menu(closed_window):
	closed_window.queue_free()
	add_child(AudioMenu.instance())

func Open_Main_Menu(closed_window):
	closed_window.queue_free()
	add_child(MenuOptions.instance())
