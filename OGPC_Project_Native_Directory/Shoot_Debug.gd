extends Label

onready var player = get_node("/root/World_Root_Node/Player_Body/Player_Gun_Base")


func _process(delta):
	self.set_text(str(player.rotation_degrees))
