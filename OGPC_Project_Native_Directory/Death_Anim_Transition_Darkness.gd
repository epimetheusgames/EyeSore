extends Node2D

onready var Death_Anim_Timer = get_node("/root/MainMenuRootNode/Level_Manager/Save_Functionality/Player_Body/Death_Animation_Timer")
var animating = false


func play_anim():
	$Death_Vignette_Player.play("Death_Vignette")

func stop_anim():
	$Death_Vignette_Player.play("Not_Dead")
