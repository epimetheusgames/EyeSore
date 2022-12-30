extends Sprite


var adjusted_mouse_sprite_position = Vector2(0, 0)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	adjusted_mouse_sprite_position.y = get_global_mouse_position().y
	adjusted_mouse_sprite_position.x = get_global_mouse_position().x
	self.position = adjusted_mouse_sprite_position
