extends Node2D

var is_in_use_range = false
var one_time_no_use = 1


func _ready():
	$Terminal_Background_Sprite.hide()
	$CanvasLayer/Press2Use.hide()
	self.add_to_group("Wire_Terminal")

func _on_Player_Use_Range_body_entered(body):
	if one_time_no_use:
		one_time_no_use -= 1
		return 
		
	if not "Player_Body" in body.name:
		return
	
	$Terminal_Background_Sprite.show()
	$CanvasLayer/Press2Use.show()
	is_in_use_range = true

func _on_Player_Use_Range_body_exited(body):
	if not "Player_Body" in body.name:
		return
	
	$Terminal_Background_Sprite.hide()
	$CanvasLayer/Press2Use.hide()
	is_in_use_range = false

func Get_Current_Camera():
	var viewport = get_viewport()
	if not viewport:
		return null
	var camerasGroupName = "__cameras_%d" % viewport.get_viewport_rid().get_id()
	var cameras = get_tree().get_nodes_in_group(camerasGroupName)
	for camera in cameras:
		if camera is Camera2D and camera.current:
			return camera
	return null

func _physics_process(delta):
	$CanvasLayer/Press2Use.rect_position = Get_Current_Camera().position / Get_Current_Camera().zoom - Vector2(get_viewport().size.x / 2, -get_viewport().size.y / 2) + Vector2($CanvasLayer/Press2Use.rect_size.x / 1.5, -10)

