extends RigidBody2D

var collision_point = Vector2(0, 0)
var tile_coordinates = Vector2(0, 0)

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
			queue_free()


func _on_RigidBody2d_body_entered(body):
	# if the node the water particle collides with is a TileMap, run the code inside
	if "TileMap" in body.name:
		# get the TileMap Node
		var tile_map = body.get_node("/root/Ground_Tilemap")
		# get the cell coordinates in world coordinates
		collision_point = body.get_collision_point(0)
		# convert the world coordinates to TileMap coordinates
		tile_coordinates = tile_map.world_to_map(collision_point)
		# set the cell at those coordinates to 0, thus deleting it, in the future will switch it to a different tile in the TileSet
		tile_map.set_cell(tile_coordinates.x, tile_coordinates.y - 1, 0)
