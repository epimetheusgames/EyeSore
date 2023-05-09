extends Node2D

onready var MenuOptions = preload("res://MenuOptions.tscn")
onready var OptionsMenu = preload("res://OptionsMenu.tscn")
onready var AudioMenu = preload("res://AudioMenu.tscn")
onready var VideoMenu = preload("res://VideoMenu.tscn")
onready var ControlsMenu = preload("res://ControlsMenu.tscn")
onready var PauseMenu = preload("res://PauseMenu.tscn")
onready var AccessibilityMenu = preload("res://AccessibilityMenu.tscn")
onready var LevelSelectMenu = preload("res://Level_Select.tscn")
onready var Credits = preload("res://CreditsScroll.tscn")
onready var LogoFade = preload("res://EpimetheusFadin.tscn")

onready var brightness = $SaveFunctionality.get_game_data()[4]["darkness"]

var game_paused = false
var level_name = "Level2"
var fade_transition = 0
var fade_finished = false

export var do_fadin = true

const levels = [
	preload("res://Levels/AestheticallyPleasingLevel.tscn"),
	preload("res://Levels/Tutorial1.tscn"),
	preload("res://Levels/Tutorial2.tscn"),
	preload("res://Levels/Tutorial_3.tscn"),
	preload("res://Levels/Tutorial_4.tscn"),
	preload("res://Levels/PUZZLE5.tscn"),
	preload("res://Levels/PUZZLE6.tscn"),
	preload("res://Levels/PUZZLE3.tscn"),
	preload("res://Levels/ExamplePuzzleLevel.tscn"),
	preload("res://Levels/PuzzleLevel2.tscn"),
	preload("res://Levels/PuzzleLevel3.tscn"),
	preload("res://Levels/PortalTutorial1.tscn"),
	preload("res://Levels/PortalTutorial3.tscn"),
	preload("res://Levels/PortalUnmanualTutorial.tscn"),
	preload("res://Levels/BlockSpikeLevel.tscn"),
	preload("res://Levels/Boss.tscn"),
]

const level_names = [
	"res://Levels/AestheticallyPleasingLevel.tscn",
	"res://Levels/Tutorial1.tscn",
	"res://Levels/Tutorial2.tscn",
	"res://Levels/Tutorial_3.tscn",
	"res://Levels/Tutorial_4.tscn",
	"res://Levels/PUZZLE5.tscn",
	"res://Levels/PUZZLE6.tscn",
	"res://Levels/PUZZLE3.tscn",
	"res://Levels/ExamplePuzzleLevel.tscn",
	"res://Levels/PuzzleLevel2.tscn",
	"res://Levels/PuzzleLevel3.tscn",
	"res://Levels/PortalTutorial1.tscn",
	"res://Levels/PortalTutorial3.tscn",
	"res://Levels/PortalUnmanualTutorial.tscn",
	"res://Levels/BlockSpikeLevel.tscn",
	"res://Levels/Boss.tscn",
]

func _ready():
	if do_fadin:
		add_child(LogoFade.instance())
	else:
		add_child(MenuOptions.instance())
	
	Set_Screen_Brightness(brightness)
	
	var data = $SaveFunctionality.get_game_data()
	
	AudioServer.set_bus_volume_db(1, linear2db(data[5]/100))
	AudioServer.set_bus_mute(1, data[5] < 0.01)
	AudioServer.set_bus_volume_db(2, linear2db(data[6]/100))
	AudioServer.set_bus_mute(2, data[6] < 0.01)
	
	$BackgroundMusic.playing = true
	# Play Main Menu Audio
	
func Next_Level(level, data, temp_level_num = -1):
	var level_obj = levels[level].instance()
	level_name = level_obj.name
	level_obj.set_player_spawnpoint_and_position(data[1], data[2], data[3], data[7], data[8], data[9])
	level_obj.temp_current_level = temp_level_num
	Play_Grass_Area_Music()
	get_node(Get_Level_Name()).queue_free()
	level_name = level_obj.name
	add_child(level_obj)
	
func Open_Options_Menu(closed_window):
	if Get_Level_Name():
		get_node(Get_Level_Name()).visible = false
	
	closed_window.queue_free()
	add_child(OptionsMenu.instance())

func Open_Audio_Menu(closed_window):
	closed_window.queue_free()
	add_child(AudioMenu.instance())
	
func Open_Level_Select_Menu(closed_window):
	closed_window.queue_free()
	add_child(LevelSelectMenu.instance())

func Open_Main_Menu(closed_window):
	closed_window.queue_free()
	if not game_paused:
		add_child(MenuOptions.instance())
	else:
		Open_Pause_Menu()

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
	
	get_node(Get_Level_Name()).visible = true
	get_node(Get_Level_Name()).get_node("Save_Functionality").get_node("AudioStreamPlayer").playing = false
	
	var whole_level_cam = get_node(Get_Level_Name()).get_node("Save_Functionality").get_node("Camera2D")
	var player_cam = get_node(Get_Level_Name()).get_node("Save_Functionality").get_node("Player_Body").get_node("Camera2D")
	
	if not get_node(Get_Level_Name()).player_camera_level:
		whole_level_cam.current = true
		$PauseMenu.position = whole_level_cam.position
	else:
		player_cam.current = true
		$PauseMenu.position = player_cam.get_parent().position
	
	if get_node(Get_Level_Name()).zoomed_level:
		$PauseMenu.scale = Vector2(0.5, 0.5)
	
func Close_Pause_Menu(closed_window):
	closed_window.queue_free() 
	game_paused = false
	get_tree().paused = false
	get_node(Get_Level_Name()).get_node("Save_Functionality").get_node("AudioStreamPlayer").playing = true
	
func Close_Pause_Menu_To_Main(closed_window):
	get_node(Get_Level_Name()).queue_free()
	closed_window.queue_free()
	game_paused = false
	$BackgroundMusic.play()
	get_tree().paused = false
	add_child(MenuOptions.instance())
	
func Open_Credits(closed_window):
	closed_window.queue_free()
	get_node(Get_Level_Name()).queue_free()
	game_paused = false
	get_tree().paused = false
	add_child(Credits.instance())
	
func Set_Screen_Brightness(brightness):
	$Node2D/ColorRect.color = Color(0, 0, 0, brightness)
		
func Play_Grass_Area_Music():
	pass
	
func Play_Boss_Music():
	$BossMusic.play()
	
func Play_OWIE_Player():
	$OWIE_Player.play()
	
func Play_Shooting_SFX_Player():
	$Shooting_SFX_Player.play()

func Play_Click_SFX():
	$ClickAudio.play()

func _process(delta):
	
	if not get_node("EpimetheusFadin"):
		if sin(deg2rad(fade_transition)) < 1-$SaveFunctionality.get_game_data()[4]["darkness"]:
			fade_transition += 1
			
			brightness = 1-sin(deg2rad(fade_transition))
		
			Set_Screen_Brightness(brightness)
