extends CharacterBody2D
class_name Minecart

@onready var sprite: Sprite2D = $Sprite2D
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var anim_tree: AnimationTree = $AnimationTree

@export var speed: int = 25

const DIRECTIONS = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]

var track_tilemap: TileMapLayer
var debug_tilemap: TileMapLayer
var start_pos: Marker2D
var end_pos: Marker2D

var all_paths: Array = []

func _ready() -> void:
	track_tilemap = get_tree().get_first_node_in_group("minecart_tracks")
	debug_tilemap = get_tree().get_first_node_in_group("debug")
	start_pos = get_tree().get_first_node_in_group("minecart_start")
	end_pos = get_tree().get_first_node_in_group("minecart_end")
	
	var tile_coord = track_tilemap.local_to_map(start_pos.position)
	position = track_tilemap.map_to_local(tile_coord)

func _physics_process(_delta: float) -> void:
	pass
	


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		debug_tilemap.clear()
		var path: Array[Vector2i]
		path.append(track_tilemap.local_to_map(start_pos.position))
		create_paths(track_tilemap.local_to_map(start_pos.position), track_tilemap.get_used_cells(), path)
		var tracks: Array[Vector2i] = find_best_path()
		print("Best Path: ", tracks)
		for track in tracks:
			debug_tilemap.set_cell(track,2,Vector2i(1,0))
		debug_tilemap.set_cell(tracks.back(), 2, Vector2i(0,0))

# Find all neighbours of the current track tile
	# For each neighbour
		# create a path
		# find the neighbours RECURSIVE
			# pick the best neighbour
				# add to path
	# look at all the paths and pick the closest to the end pos.

func find_best_path() -> Array[Vector2i]:
	var best_path: Array[Vector2i] = []
	var distance: int = 2000
	var count: int = 0
	for path in all_paths:
		var current_distance: int = abs(path.back().x - end_pos.position.x)
		print("Path ", count, ":", path, " | Distance: ", current_distance, " | Current closest Distance: ", distance)
		if  current_distance <= distance:
			distance = current_distance
			best_path = path
		count +=1
	return best_path
	

func create_paths(tile: Vector2i, tracks: Array[Vector2i], current_path: Array[Vector2i]):
	var possible_paths = find_neighours(tile, tracks)
	var valid_next_steps: Array[Vector2i] = []
	
	for path in possible_paths:
		if not current_path.has(path):
			valid_next_steps.append(path)

	if valid_next_steps.size() == 0:
		all_paths.append(current_path)
		return
	
	for next in valid_next_steps:
		var new_path = current_path.duplicate()
		new_path.append(next)
		create_paths(next, tracks, new_path)

func find_neighours(tile: Vector2i, tracks: Array[Vector2i]) -> Array[Vector2i]:
	var neighbours: Array[Vector2i] = []
	for dir in DIRECTIONS:
		var check_tile: Vector2i = tile + dir
		if tracks.has(check_tile):
			neighbours.append(check_tile)
	return neighbours
