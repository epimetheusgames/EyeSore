extends RigidBody2D

func _ready():
	contact_monitor = true 
	contacts_reported = 100

func _process(delta):
	for body in get_colliding_bodies():
		if not "Water_Particle" in body.name and body.name != "Player_Body":
			queue_free()
