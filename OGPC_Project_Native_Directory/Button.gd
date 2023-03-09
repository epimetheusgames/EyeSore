extends Node2D


func _ready():
	add_to_group("buttons")

func _on_Area2D_area_entered(area):
	if $AnimatedSprite.animation == "Unpressing" and "Player" in area.name:
		$AnimatedSprite.animation = "Pressing"
		$AnimatedSprite.play()
		Player_Manage_Wires()

func _on_Area2D_area_exited(area):
	if $AnimatedSprite.animation == "Pressing" and "Player" in area.name:
		$AnimatedSprite.animation = "Unpressing"
		$AnimatedSprite.play()
		Player_Manage_Wires()

func Player_Manage_Wires():
	var grass_tileset = get_parent().get_node("TileMap")
	var tileset = get_parent().get_node("Spikes_TileMap")
	var death_pos_on_tileset = tileset.world_to_map(position + $Area2D.scale / 2)
	
	get_parent().get_node("Player_Body").manage_wires(death_pos_on_tileset, tileset, grass_tileset)

