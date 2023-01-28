tool
extends TileSet

const GROUND = 0
const SPIKES = 1
const DARK = 4

var binds = {
	SPIKES : [GROUND, DARK],
	GROUND : [DARK],
	DARK : [GROUND]
}

func _is_tile_bound(drawn_id, neighbor_id):
	if drawn_id in binds:
		return neighbor_id in binds[drawn_id]
	return false
