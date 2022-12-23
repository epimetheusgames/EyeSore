extends Node2D

onready var MenuOptions = preload("res://MenuOptions.tscn")
onready var OptionsMenu = preload("res://OptionsMenu.tscn")
onready var AudioMenu = preload("res://AudioMenu.tscn")
onready var VideoMenu = preload("res://VideoMenu.tscn")

func _ready():
	add_child(MenuOptions.instance())
	$BackgroundMusic.playing = true
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

func Open_Video_Menu(closed_window):
	closed_window.queue_free()
	add_child(VideoMenu.instance())

func Play_Click_SFX():
	$ClickAudio.play()
