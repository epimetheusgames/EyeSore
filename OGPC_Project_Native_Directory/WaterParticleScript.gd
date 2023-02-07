extends RigidBody2D

var collision_point = Vector2(0, 0)
var tile_coordinates = Vector2(0, 0)
var tile_pos

func _ready():
	contact_monitor = true 
	contacts_reported = 100
	connect("body_entered", self, "_on_RigidBody2d_body_entered")

func _process(delta):
	# iterate through all the bodies colliding with the water particle
	for body in get_colliding_bodies():
		# if the colliding body is not another water particle, or the player, run the code inside
		if not "Water_Particle" in body.name and body.name != "Player_Body":
			# delete this water particle
			self.queue_free()


func _on_RigidBody2d_body_entered(body):
	# if the node the water particle collides with is a TileMap, run the code inside
	if "TileMap" in body.name:
		# get the TileMap Node
		var tile_map = body
		
		var mask = tile_map.get_collision_mask()
		
		if mask > 0:
			get_node("/root/MainMenuRootNode/Tile_Converted_SFX_Player").play()
			
			tile_pos = tile_map.world_to_map(self.position)
			tile_map.set_cell(tile_pos.x, tile_pos.y, -1)
			tile_map.update_bitmask_area(tile_pos)
			self.queue_free()
