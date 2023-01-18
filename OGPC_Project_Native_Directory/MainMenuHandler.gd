extends Node2D

onready var MenuOptions = preload("res://MenuOptions.tscn")
onready var OptionsMenu = preload("res://OptionsMenu.tscn")
onready var AudioMenu = preload("res://AudioMenu.tscn")
onready var VideoMenu = preload("res://VideoMenu.tscn")
onready var ControlsMenu = preload("res://ControlsMenu.tscn")
onready var PauseMenu = preload("res://PauseMenu.tscn")
onready var AccessibilityMenu = preload("res://AccessibilityMenu.tscn")

var game_paused = false
var level_name = ""

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
	if not game_paused:
		add_child(MenuOptions.instance())
	else:
		add_child(PauseMenu.instance())

func Open_Video_Menu(closed_window):
	closed_window.queue_free()
	add_child(VideoMenu.instance())
	
func Open_Controls_Menu(closed_window):
	closed_window.queue_free()
	add_child(ControlsMenu.instance())
	
func Open_Other(closed_window, opened_window, remove_sounds):
	level_name = opened_window.name
	closed_window.queue_free()
	add_child(opened_window)
	
	if remove_sounds:
		$BackgroundMusic.stop()
		
func Open_Pause_Menu():
	# Play pause menu bg music here
	game_paused = true 
	get_tree().paused = true
	$Grass_Area_Music_Player.stop()
	add_child(PauseMenu.instance())
	$PauseMenu.position = get_node(level_name).get_node("Save_Functionality").get_node("Player_Body").position
	
func Close_Pause_Menu(closed_window):
	closed_window.queue_free()
	game_paused = false
	$Grass_Area_Music_Player.play()
	get_node(level_name).get_node("Save_Functionality").get_node("Player_Body").get_node("Camera2D").current = true
	get_tree().paused = false
	
func Close_Pause_Menu_To_Main(closed_window):
	get_node("Level_Manager").queue_free()
	closed_window.queue_free()
	game_paused = false
	$BackgroundMusic.play()
	get_tree().paused = false
	add_child(MenuOptions.instance())
	
func Set_Screen_Brightness(brightness):
	$Node2D/ColorRect.color = Color(0, 0, 0, brightness)
		
func Play_Grass_Area_Music():
	$Grass_Area_Music_Player.play()
	
func Play_OWIE_Player():
	$OWIE_Player.play()
	
func Play_Shooting_SFX_Player():
	$Shooting_SFX_Player.play()

func Play_Click_SFX():
	$ClickAudio.play()
