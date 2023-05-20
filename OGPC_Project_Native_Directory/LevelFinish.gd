extends Node2D


func _ready():
	add_to_group("levelfinishers")

func _on_Area2D_area_entered(area):
	# if the player touches the checkpoint, save.
	if area.name == "Player_Body":
		save_level()

func _on_Area2D_body_entered(body):
	if body.name == "Player_Body":
		save_level()
		
func save_level():
	if get_parent().get_node("Boss_Body") != null:
		get_parent().get_node("Player_Body/Death_Anim_Transition").hide()
		get_parent().get_node("Boss_Body").state_machine.stop()
		get_parent().get_node("Boss_Body").state_machine.start("Death")
	yield(get_tree().create_timer(2), "timeout")
	get_parent().next_level()
