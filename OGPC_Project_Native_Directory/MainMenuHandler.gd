extends Node2D

onready var MenuOptions = preload("res://MenuOptions.tscn")
onready var OptionsMenu = preload("res://OptionsMenu.tscn")
onready var AudioMenu = preload("res://AudioMenu.tscn")
onready var VideoMenu = preload("res://VideoMenu.tscn")
onready var ControlsMenu = preload("res://ControlsMenu.tscn")

func _ready():
	print($OWIE_Player.get_path())
	
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
	
func Open_Controls_Menu(closed_window):
	closed_window.queue_free()
	add_child(ControlsMenu.instance())
	
func Open_Other(closed_window, opened_window, remove_sounds):
	closed_window.queue_free()
	add_child(opened_window)
	
	if remove_sounds:
		$BackgroundMusic.queue_free()
		$ClickAudio.queue_free()
		
func Play_Grass_Area_Music():
	$Grass_Area_Music_Player.play()
	
func Play_OWIE_Player():
	$OWIE_Player.play()
	
func Play_Shooting_SFX_Player():
	$Shooting_SFX_Player.play()

func Play_Click_SFX():
	$ClickAudio.play()
