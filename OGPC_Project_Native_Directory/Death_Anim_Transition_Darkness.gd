extends Node2D

onready var Death_Anim_Timer = get_node("/root/MainMenuRootNode/Level_Manager/Save_Functionality/Player_Body/Death_Animation_Timer")
var animating = false


func _ready():
	visible = true

func play_anim():
	visible = true
	$Death_Vignette_Player.play("Death_Vignette")

func stop_anim():
	visible = false
