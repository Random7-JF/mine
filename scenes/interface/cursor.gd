extends Node2D

var tilemap : TileMapLayer
var sprite : Sprite2D

func _ready() -> void:
	tilemap = get_tree().get_first_node_in_group("world_map")
	sprite = $Cursor_Overlay

func _process(_delta: float) -> void:
	if not tilemap or not sprite:
		return
	
	var tile_coords: Vector2 = tilemap.local_to_map(get_global_mouse_position())
	var tile: Vector2 = tilemap.map_to_local(tile_coords)
	
	sprite.global_position = tile

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("place_tile"):
		var tile_coords: Vector2 = tilemap.local_to_map(get_global_mouse_position())
		print(tile_coords)
