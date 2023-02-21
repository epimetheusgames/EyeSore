extends Node2D

var side1_pressed = false
var side2_pressed = false

export var moveable = true
export var moveable_color = Color(0, 0, 0, 0)
export var unmoveable_color = Color(0, 0, 0, 0)

var wire_ui = false
var tileset = null

func _ready():
	if moveable:
		side1_pressed = true
	
	add_to_group("wires")
	
	move_button_to_line($Side1, 0)
	move_button_to_line($Side2, 1)
	
	if moveable:
		$Line2D.default_color = moveable_color
	else:
		$Side1Icon.visible = false
		$Side2Icon.visible = false
		$Line2D.default_color = unmoveable_color

func is_mouse_pressed():
	if Input.is_action_pressed("mouse_click"):
		return true 
	return false 
	
func move_button_and_line_to_mouse(button, side_num):
	$Line2D.points[side_num] = get_local_mouse_position()
	button.rect_position = get_local_mouse_position() - button.rect_size / 2
	
func move_button_to_line(button, side_num):
	button.rect_position = $Line2D.points[side_num] - button.rect_size / 2

func _process(delta):
	$Line2D.points[0] = tileset.map_to_world(tileset.world_to_map($Line2D.points[0])) + tileset.cell_size / 2
	$Line2D.points[1] = tileset.map_to_world(tileset.world_to_map($Line2D.points[1])) + tileset.cell_size / 2
	
	if moveable:
		$Side1Icon.set_position($Line2D.points[0] - $Side1Icon.rect_size / 2)
		$Side2Icon.set_position($Line2D.points[1] - $Side2Icon.rect_size / 2)
		
	if wire_ui and moveable:
		$Side1Icon.visible = true 
		$Side2Icon.visible = true
	else:
		$Side1Icon.visible = false 
		$Side2Icon.visible = false
		
	
	if side1_pressed:
		move_button_and_line_to_mouse($Side1, 0)
	elif side2_pressed:
		move_button_and_line_to_mouse($Side2, 1)

func _on_Side1_button_down():
	if moveable and wire_ui:
		side1_pressed = true

func _on_Side1_button_up():
	if moveable and wire_ui:
		if get_parent().get_parent().is_point_on_connections($Line2D.points[0]):
			side1_pressed = false
		else:
			queue_free()

func _on_Side2_button_down():
	if moveable and wire_ui:
		side2_pressed = true

func _on_Side2_button_up():
	if moveable and wire_ui:
		side2_pressed = false
	
func is_selected():
	if side1_pressed or side2_pressed:
		return true 
	return false
	
func get_tileset_coords(point_ind, tileset):
	return tileset.world_to_map($Line2D.points[point_ind])
	
func get_touching_checkpoint(point_ind):
	var checkpoints = get_tree().get_nodes_in_group("checkpoints")
	
	for checkpoint in checkpoints:
		if checkpoint.is_point_inside($Line2D.points[point_ind]):
			return checkpoint
			
	return false
	
func delete_tile_at(point_ind, tileset, is_grass, spike_coords, spike_coord_types):
	var pos = get_tileset_coords(point_ind, tileset)
	
	if tileset.get_cell(pos.x, pos.y) == -1 and is_grass and not pos in get_parent().get_parent().deleted_spikes:
		tileset.set_cell(pos.x, pos.y, 0)
	elif tileset.get_cell(pos.x, pos.y) == -1 and not is_grass and pos in get_parent().get_parent().deleted_spikes:
		var ind = spike_coords.find(pos, 0)
		tileset.set_cell(pos.x, pos.y, spike_coord_types[ind])
	elif tileset.get_cell(pos.x, pos.y) != -1:
		var type = tileset.get_cell(pos.x, pos.y)
		tileset.set_cell(pos.x, pos.y, -1)
		if not is_grass:
			return [true, type, Vector2(pos.x, pos.y)]
	
	tileset.update_bitmask_region()

func set_pos(pos):
	$Line2D.points[0] = pos 
	$Line2D.points[1] = pos
	$Side1.rect_position = pos - $Side1.rect_size / 2
	$Side2.rect_position = pos - $Side2.rect_size / 2
