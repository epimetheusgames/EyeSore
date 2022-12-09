extends KinematicBody2D

var grow = 0.5
var grow_amount = 0.8
var timer = 32


func _physics_process(delta):
	if timer > 0:
		$CollisionShape2D.disabled = false
		
		self.scale = Vector2(grow, grow)
		grow += grow_amount
		timer -= 1
	else:
		$CollisionShape2D.disabled = true
		grow_amount = 4
		
		self.scale = Vector2(grow, grow)
		grow += grow_amount
