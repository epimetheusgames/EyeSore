extends Node2D

export var entrance = true
var active = false

func _ready():
	add_to_group("portals")

func _on_TeleportationArea_body_entered(body):
	if "MoveableBlock" in body.name and active and entrance:
		var wires = get_tree().get_nodes_in_group("wires")
			
		for wire in wires:
			var portal = wire.get_touching_portal(1)
			if portal and portal[0] == self and portal[1]:
				var other_side = wire.get_touching_portal(0)
				
				if other_side and not other_side[1]:
					body.set_telepoint(other_side[0].get_node("PortalTelepoint").global_position)

func _process(delta):
	if active:
		$RigidBody2D/CollisionPolygon2D.disabled = false
		$PortalSprite.visible = false
		$PortalSpriteActive.visible = true
	else:
		$RigidBody2D/CollisionPolygon2D.disabled = true
		$PortalSprite.visible = true
		$PortalSpriteActive.visible = false

func is_point_inside(point):
	var rect = Rect2(to_global($ReferenceRect.rect_position), $ReferenceRect.rect_size)
	
	return rect.has_point(point)
