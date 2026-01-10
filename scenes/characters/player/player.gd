extends CharacterBody2D
class_name Player

@export var walk_speed:int = 150
@export var tracks: int = 50

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var weapon: Node2D = $Weapon
@onready var cursor: Node2D = $Cursor

signal track_changed
signal update_mode

enum PLAYER_MODE {
	Track,
	Weapon,
	Interact,
	Nothing
}
var current_mode: PLAYER_MODE = PLAYER_MODE.Nothing
var minetracks_tilemap: TileMapLayer

var isRunning: bool = false
var last_direction: Vector2

func _ready() -> void:
	animation_tree.active = true
	minetracks_tilemap = get_tree().get_first_node_in_group("minecart_tracks")

func _process(_delta: float) -> void:
	match current_mode:
		PLAYER_MODE.Track:
			cursor.visible = true
			weapon.visible = false
		PLAYER_MODE.Weapon:
			weapon.visible = true
			cursor.visible = false
			weapon.rotation = (get_global_mouse_position() - global_position).angle() + deg_to_rad(90)
		PLAYER_MODE.Nothing:
			weapon.visible = false
			cursor.visible = false

func _physics_process(_delta):
	# TODO just adding controls in to test, need to make a proper input system.
	# TODO create a better feeling movement system with some smoothing in it.
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
	move_and_slide()
	
	#Animation
	if velocity != Vector2.ZERO:
		last_direction = velocity.normalized()
	isRunning = velocity != Vector2.ZERO
	animation_tree.set("parameters/idle/blend_position", last_direction.x)
	animation_tree.set("parameters/run/blend_position", last_direction.x)

func _unhandled_input(_event: InputEvent) -> void:
	if current_mode == PLAYER_MODE.Track:
		if Input.is_action_just_pressed("place_tile"):
			place_tile()
		if Input.is_action_just_pressed("remove_tile"):
			remove_tile()
	if Input.is_action_just_pressed("track_mode"):
		current_mode = PLAYER_MODE.Track
		update_mode.emit()
	if Input.is_action_just_pressed("weapon_mode"):
		current_mode = PLAYER_MODE.Weapon
		update_mode.emit()
	if Input.is_action_just_pressed("nothing_mode"):
		current_mode = PLAYER_MODE.Nothing
		update_mode.emit()

func place_tile():
	track_changed.emit()
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
	track_changed.emit()
	# TODO I don't want the player adding tiles to a tile map,
	# rather have a World manager, have the player call out to it.
	var tile_coords: Vector2i = minetracks_tilemap.local_to_map(get_global_mouse_position())
	var tile : TileData = minetracks_tilemap.get_cell_tile_data(tile_coords)
	if tile:
		minetracks_tilemap.set_cell(tile_coords,-1,Vector2i(-1,-1),0)
		print_debug("Tile removed: ", tile)
		tracks += 1
