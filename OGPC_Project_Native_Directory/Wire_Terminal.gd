extends Node2D

export (float, 1, 1000) var frequency = 5
export (float, 1000) var amplitude = 150
var time = 0

var is_in_use_range = false
var one_time_no_use = 1


func _ready():
	$Terminal_Background_Sprite.hide()
	self.add_to_group("Wire_Terminal")

func _on_Player_Use_Range_body_entered(body):
	if one_time_no_use:
		one_time_no_use -= 1
		return 
	
	$Terminal_Background_Sprite.show()
	is_in_use_range = true

func _on_Player_Use_Range_body_exited(body):
	$Terminal_Background_Sprite.hide()
	is_in_use_range = false

func _physics_process(delta):
	time += delta
	var movement = cos(time * frequency) * amplitude
	$Btn_Prompt_Spr.position.y += (movement * delta)
	
	if is_in_use_range:
		$Btn_Prompt_Spr.visible = true 
	else:
		$Btn_Prompt_Spr.visible = false
