extends Camera2D

var tilemap: TileMapLayer

func _ready() -> void:
	tilemap = get_tree().get_first_node_in_group("world_map")
	if tilemap:
		var used_rect: Rect2i = tilemap.get_used_rect()
		var tile_size: int = tilemap.tile_set.get_tile_size().x
		limit_left = used_rect.position.x
		limit_top = used_rect.position.y * tile_size
		limit_right = (used_rect.position.x + used_rect.size.x) * tile_size
		limit_bottom = (used_rect.position.y + used_rect.size.y) * tile_size
	else:
		print_debug("No tilemap bounds found.")
