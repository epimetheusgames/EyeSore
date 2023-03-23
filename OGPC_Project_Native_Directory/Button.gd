extends Node2D

export var toggle = false
var finished = false
var first_time = true

func _ready():
	add_to_group("buttons")

func _on_Area2D_area_entered(area):
	print(area.name)
	if $AnimatedSprite.animation == "Unpressing" and finished and ("Player" in area.name or "MoveableBlock" in area.name):
		$AnimatedSprite.animation = "Pressing"
		$AnimatedSprite.play()

func _on_Area2D_area_exited(area):
	if $AnimatedSprite.animation == "Pressing" and ("Player" in area.name or "MoveableBlock" in area.name):
		finished = false
		$AnimatedSprite.animation = "Unpressing"
		$AnimatedSprite.play()
			
func _on_Area2D_body_entered(body):
	_on_Area2D_area_entered(body)

func _on_Area2D_body_exited(body):
	_on_Area2D_area_exited(body)

func Player_Manage_Wires():
	var grass_tileset = get_parent().get_node("TileMap")
	var tileset = get_parent().get_node("Spikes_TileMap")
	var death_pos_on_tileset = tileset.world_to_map(position + $Area2D.scale / 2)
	
	get_parent().get_node("Player_Body").manage_wires(death_pos_on_tileset, tileset, grass_tileset)

func _on_AnimatedSprite_animation_finished():
	finished = true
	if $AnimatedSprite.animation == "Unpressing":
		if not toggle and not first_time:
			Player_Manage_Wires()
		elif first_time:
			first_time = false
	elif $AnimatedSprite.animation == "Pressing":
		Player_Manage_Wires()
