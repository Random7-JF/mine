extends CharacterBody2D

@export var walk_speed:int = 150
@export var tracks: int = 5

var minetracks_tilemap: TileMapLayer

func _ready() -> void:
	minetracks_tilemap = get_tree().get_first_node_in_group("minetracks")

func _physics_process(_delta):
	# TODO just adding controls in to test, need to make a proper input system.
	if Input.is_action_pressed("move_left"):
		velocity.x = -walk_speed
	elif Input.is_action_pressed("move_right"):
		velocity.x =  walk_speed
	elif Input.is_action_pressed("move_up"):
		velocity.y = -walk_speed
	elif Input.is_action_pressed("move_down"):
		velocity.y = walk_speed
	else:
		velocity = Vector2.ZERO
	
	if Input.is_action_just_pressed("place_tile"):
		place_tile()
	if Input.is_action_just_pressed("remove_tile"):
		remove_tile()
	
	move_and_slide()
	
func place_tile():
	var tile_coords: Vector2i = minetracks_tilemap.local_to_map(get_global_mouse_position())
	var tile : TileData = minetracks_tilemap.get_cell_tile_data(tile_coords)
	
	if not tile and tracks >= 1:
		# TODO I don't want the player adding tiles to a tile map,
		# rather have a World manager, have the player call out to it.
		var cells: Array[Vector2i] = [tile_coords]
		minetracks_tilemap.set_cells_terrain_connect(cells, 0, 0, false)
		print_debug("Tile Added at ", tile_coords)
		tracks -= 1
	else:
		print_debug("No Tracks Left.")

func remove_tile():
	# TODO I don't want the player adding tiles to a tile map,
	# rather have a World manager, have the player call out to it.
	var tile_coords: Vector2i = minetracks_tilemap.local_to_map(get_global_mouse_position())
	var tile : TileData = minetracks_tilemap.get_cell_tile_data(tile_coords)
	if tile:
		minetracks_tilemap.set_cell(tile_coords,-1,Vector2i(-1,-1),0)
		print_debug("Tile removed: ", tile)
		tracks += 1
