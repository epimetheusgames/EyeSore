tool
extends TileSet

const GROUND = 0
const SPIKES = 1

var binds = {
	GROUND : [SPIKES],
	SPIKES : [GROUND]
}

func _is_tile_bound(drawn_id, neighbor_id):
	if drawn_id in binds:
		return neighbor_id in binds[drawn_id]
	return false
