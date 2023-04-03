extends Area2D

onready var player_body = get_parent().get_node("Player_Body")
var speed = 1

func _physics_process(delta):
	self.position.x -= speed
	
	if player_body.position.distance_to(self.position) > 365:
		speed += 0.008
	elif player_body.position.distance_to(self.position) < 365 and speed >= 0.8:
		speed -= 0.02
