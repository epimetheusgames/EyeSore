extends Node2D

onready var Death_Anim_Timer = get_node("/root/MainMenuRootNode/Level_Manager/Save_Functionality/Player_Body/Death_Animation_Timer")

var has_played_Death_Vignette = false


func _physics_process(delta):
	if Death_Anim_Timer.time_left >= 0:
		has_played_Death_Vignette = false
	if Death_Anim_Timer.time_left > 0 and Death_Anim_Timer.time_left < 0.9 and has_played_Death_Vignette == false:
		$Death_Vignette_Player.play("Death_Vignette")
		has_played_Death_Vignette = false
	elif $Death_Vignette_Player.is_playing() == false:
		$Death_Vignette_Player.stop(true)
