extends KinematicBody2D


export var point1 = Vector2(0, 0)
export var point2 = Vector2(0, 0)
export var speed = 1

var going_to_point1 = false


func distance(x1, y1, x2, y2):
	return sqrt(pow((x2 - x1), 2) + pow((y2 - y1), 2))


func _physics_process(delta):
	if going_to_point1:
		position += (point1 - point2).normalized() * speed
		if distance(position.x, position.y, point1.x, point1.y) < 10:
			going_to_point1 = false
	else:
		position += (point2 - point1).normalized() * speed
		if distance(position.x, position.y, point2.x, point2.y) < 10:
			going_to_point1 = true
