extends Node2D

var transparency = 0
var sin_transparency = -90


func _physics_process(delta):
	if sin_transparency > 230:
		get_parent().Open_Main_Menu(self)
		return
	
	sin_transparency += 0.5
	
	transparency = sin(deg2rad(sin_transparency))
	
	$EpimetheusLogoLarge.modulate = Color(1, 1, 1, (transparency) / 2) 
