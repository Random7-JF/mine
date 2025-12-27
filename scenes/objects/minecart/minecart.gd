extends CharacterBody2D
class_name Minecart

@onready var sprite: Sprite2D = $Sprite2D
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var anim_tree: AnimationTree = $AnimationTree

@export var speed: int = 25

var track_tilemap: TileMapLayer
var debug_tilemap: TileMapLayer
var start_pos: Marker2D
var end_pos: Marker2D

var tracks: Array[Vector2i] = []
var move_to: Vector2i

func _ready() -> void:
	track_tilemap = get_tree().get_first_node_in_group("minecart_tracks")
	debug_tilemap = get_tree().get_first_node_in_group("debug")
	start_pos = get_tree().get_first_node_in_group("minecart_start")
	end_pos = get_tree().get_first_node_in_group("minecart_end")
	
	var tile_coord = track_tilemap.local_to_map(start_pos.position)
	position = track_tilemap.map_to_local(tile_coord)


func _process(_delta: float) -> void:
	var new_tracks: Array[Vector2i] = track_tilemap.get_used_cells()
	if new_tracks != tracks:
		print("updating tracks")
		tracks = new_tracks
		move_to = pick_best_neighbour()
	velocity = global_position.direction_to(track_tilemap.map_to_local(move_to)) * speed
	move_and_slide()


# Find the path of joined tiles.
const directions = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]

func find_neighbours(current_pos: Vector2i) -> Array[Vector2i]:
	var neighbours: Array[Vector2i] = []
	for dir in directions:
		var check_tile: Vector2i = current_pos + dir
		if tracks.has(check_tile):
			neighbours.append(check_tile)
	return neighbours

func pick_best_neighbour() -> Vector2i:
	tracks = track_tilemap.get_used_cells()
	var tile_coord = track_tilemap.local_to_map(position)
	var neighbours: Array[Vector2i] = find_neighbours(tile_coord)
	var closest_neighbour: Vector2i
	for neighbour in neighbours:
		if closest_neighbour == Vector2i.ZERO:
			closest_neighbour = neighbour
			print("setting closes_neighbour", closest_neighbour)
		if neighbour.distance_to(end_pos.position) < closest_neighbour.distance_to(end_pos.position):
			closest_neighbour = neighbour
			print("updating closes_neighbour", closest_neighbour)
		debug_tilemap.set_cell(neighbour,2,Vector2i(1,0))
	debug_tilemap.set_cell(closest_neighbour,2,Vector2i(0,0))
	return closest_neighbour
