extends Node2D

onready var MenuOptions = preload("res://MenuOptions.tscn")
onready var OptionsMenu = preload("res://OptionsMenu.tscn")
onready var AudioMenu = preload("res://AudioMenu.tscn")
onready var VideoMenu = preload("res://VideoMenu.tscn")
onready var ControlsMenu = preload("res://ControlsMenu.tscn")
onready var PauseMenu = preload("res://PauseMenu.tscn")
onready var AccessibilityMenu = preload("res://AccessibilityMenu.tscn")

var game_paused = false
var level_name = "Level2"

const levels = [
	preload("res://Levels/AestheticallyPleasingLevel.tscn"),
	preload("res://Levels/PortalTestLevel.tscn"),
	preload("res://Levels/Boss.tscn"),
	preload("res://Levels/PUZZLE2.tscn"),
	preload("res://Levels/PUZZLE5.tscn"),
	preload("res://Levels/PUZZLE6.tscn"),
	preload("res://Levels/PUZZLE3.tscn"),
	preload("res://Levels/ExamplePuzzleLevel.tscn"),
	preload("res://Levels/PuzzleLevel2.tscn"),
	preload("res://Levels/PuzzleLevel3.tscn"),
]

const level_names = [
	"res://Levels/AestheticallyPleasingLevel.tscn",
	"res://Levels/PortalTestLevel.tscn",
	"res://Levels/Boss.tscn",
	"res://Levels/PUZZLE2.tscn",
	"res://Levels/PUZZLE5.tscn",
	"res://Levels/PUZZLE6.tscn",
	"res://Levels/PUZZLE3.tscn",
	"res://Levels/ExamplePuzzleLevel.tscn",
	"res://Levels/PuzzleLevel2.tscn",
	"res://Levels/PuzzleLevel3.tscn",
]

func _ready():
	add_child(MenuOptions.instance())
	
	$BackgroundMusic.playing = true
	# Play Main Menu Audio
	
func Next_Level(level, data):
	var level_obj = levels[level].instance()
	level_name = level_obj.name
	level_obj.set_player_spawnpoint_and_position(data[1], data[2], data[3], data[7], data[8], data[9])
	Play_Grass_Area_Music()
	get_node(Get_Level_Name()).queue_free()
	level_name = level_obj.name
	add_child(level_obj)
	
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
		
func Get_Level_Name():
	var child_name
	
	for child in get_children():
		if "Level_Manager" in child.name:
			child_name = child.name
			
	return child_name
		
func Open_Pause_Menu():
	# Play pause menu bg music here
	game_paused = true 
	get_tree().paused = true
	add_child(PauseMenu.instance())
	
	var whole_level_cam = get_node(Get_Level_Name()).get_node("Save_Functionality").get_node("Camera2D")
	var player_cam = get_node(Get_Level_Name()).get_node("Save_Functionality").get_node("Player_Body").get_node("Camera2D")
	
	if whole_level_cam.current == true:
		$PauseMenu.position = whole_level_cam.position
		print(whole_level_cam.position)
		print($PauseMenu.position)
		print(get_local_mouse_position())
	else:
		$PauseMenu.position = player_cam.get_parent().position
	
func Close_Pause_Menu(closed_window):
	closed_window.queue_free() 
	game_paused = false
	var camera = get_node(Get_Level_Name()).get_node("Save_Functionality").get_node("Camera2D")
	get_tree().paused = false
	
func Close_Pause_Menu_To_Main(closed_window):
	get_node(Get_Level_Name()).queue_free()
	closed_window.queue_free()
	game_paused = false
	$BackgroundMusic.play()
	get_tree().paused = false
	add_child(MenuOptions.instance())
	
func Set_Screen_Brightness(brightness):
	$Node2D/ColorRect.color = Color(0, 0, 0, brightness)
		
func Play_Grass_Area_Music():
	pass
	
func Play_OWIE_Player():
	$OWIE_Player.play()
	
func Play_Shooting_SFX_Player():
	$Shooting_SFX_Player.play()

func Play_Click_SFX():
	$ClickAudio.play()
