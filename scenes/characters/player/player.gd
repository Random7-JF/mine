extends CharacterBody2D

@export var walk_speed:int = 150

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
	
	if Input.is_action_pressed("place_tile"):
		place_tile()
	
	move_and_slide()
	
func place_tile():
	# TODO I don't want the player adding tiles to a tile map,
	# rather have a World manager, have the player call out to it.
	var tile_coords: Vector2 = minetracks_tilemap.local_to_map(get_global_mouse_position())
	minetracks_tilemap.set_cell(tile_coords,0,Vector2i(8,6),0)
