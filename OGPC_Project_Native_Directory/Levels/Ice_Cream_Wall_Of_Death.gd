extends Area2D

onready var player_body = get_parent().get_node("Player_Body")
onready var original_pos = self.position.x

var speed = 1.5

func _physics_process(delta):
	self.position.x -= speed

func reset():
	self.position.x = original_pos
