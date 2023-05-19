extends Area2D

onready var player_body = get_parent().get_node("Player_Body")
onready var boss_body = get_parent().get_node("Boss_Body")
onready var original_pos = self.position.x

var speed = 1.2

func _ready():
	self.hide()
	$IceCreamWallColl.disabled = true

func _physics_process(delta):
	get_parent().get_node("Label").text = str(boss_body.state_machine.is_playing())
	if boss_body.state_machine.is_playing():
		self.show()
		$IceCreamWallColl.disabled = false
		self.position.x -= speed
		
		if player_body.position.distance_to(self.position) > 400:
			speed += 0.007
		elif player_body.position.distance_to(self.position) < 290 and speed >= 0.45:
			speed -= 0.02

func reset():
	self.position.x = original_pos
	speed = 1.3
