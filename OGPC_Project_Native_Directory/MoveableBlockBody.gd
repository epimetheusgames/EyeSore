extends RigidBody2D

func set_telepoint(point):
	global_transform.origin = point
