extends Node2D

@export var track_cursor: Texture2D
@export var interact_cursor: Texture2D

var player: Player
var tilemap: TileMapLayer
var sprite: Sprite2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	tilemap = get_tree().get_first_node_in_group("world_map")
	sprite = $Cursor_Overlay
	
	if player:
		player.connect("update_mode", update_cursor)

func _process(_delta: float) -> void:
	if not tilemap or not sprite:
		return
	
	var tile_coords: Vector2 = tilemap.local_to_map(get_global_mouse_position())
	var tile: Vector2 = tilemap.map_to_local(tile_coords)
	
	sprite.global_position = tile

func update_cursor():
	print("Update")
	match player.current_mode:
		Player.PLAYER_MODE.Track:
			sprite.texture = track_cursor
			print("track cursor")
		Player.PLAYER_MODE.Interact:
			sprite.texture = interact_cursor
			print("Interact cursor")
