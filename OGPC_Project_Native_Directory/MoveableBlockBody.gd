extends RigidBody2D

func set_telepoint(point):
	print(point)
	print(global_transform.origin)
	print(global_position)
	global_transform.origin = point
	print(global_transform.origin)
