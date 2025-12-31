extends CharacterBody2D
class_name Minecart

@onready var sprite: Sprite2D = $Sprite2D
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var anim_tree: AnimationTree = $AnimationTree

@export var speed: int = 25

const directions = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]

var track_tilemap: TileMapLayer
var debug_tilemap: TileMapLayer
var start_pos: Marker2D
var end_pos: Marker2D

var path: Array[Vector2i] = []
var path_index: int = 0
var tracks: Array[Vector2i] = []

func _ready() -> void:
	track_tilemap = get_tree().get_first_node_in_group("minecart_tracks")
	debug_tilemap = get_tree().get_first_node_in_group("debug")
	start_pos = get_tree().get_first_node_in_group("minecart_start")
	end_pos = get_tree().get_first_node_in_group("minecart_end")
	
	var tile_coord = track_tilemap.local_to_map(start_pos.position)
	position = track_tilemap.map_to_local(tile_coord)

func _physics_process(_delta: float) -> void:
	if path.size() > 0:
		var dir = position.direction_to(path[path_index+1]).normalized()
		print(dir)
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		debug_tilemap.clear()
		update_connected_tracks()
		for coord in path:
			debug_tilemap.set_cell(coord,2,Vector2i(1,0))
		debug_tilemap.set_cell(path[path.size()-1], 2, Vector2i(0,0))


func update_connected_tracks() -> void:
	var current_pos = track_tilemap.local_to_map(position)	
	path = []
	path.append(current_pos)
	tracks = track_tilemap.get_used_cells()
	
	var scanning: bool = true
	while scanning:
		var neighbours: Array[Vector2i] = find_neighbour_tracks(current_pos)
		var possible_path: Array[Vector2i] = []
		for neighbour in neighbours:
			## TODO scan neighbours of neighbours here?
			if not path.has(neighbour):
				possible_path.append(neighbour)
		if possible_path.size() > 0:
			var next_neighbour = find_best_neighbour(possible_path)
			if next_neighbour == Vector2i.ZERO:
				print_debug("0,0 best neighbour? how'd we get here.")
				scanning = false
			path.append(next_neighbour)
			current_pos = next_neighbour
			if current_pos == track_tilemap.local_to_map(end_pos.position):
				print_debug("we are at the end point")
				scanning = false
		else:
			print_debug("we hit the last farthest track")
			scanning = false
	print("Current Path: ", path)

func find_neighbour_tracks(pos: Vector2i) -> Array[Vector2i]:
	var neighbours: Array[Vector2i] = []
	for dir in directions:
		var check_tile: Vector2i = pos + dir
		if tracks.has(check_tile):
			neighbours.append(check_tile)
	return neighbours

func find_best_neighbour(neighbours: Array[Vector2i]) -> Vector2i:
	var best_neighbour: Vector2i = Vector2i.ZERO
	var distance: float = 9999.9
	for neighbour in neighbours:
		var neighbour_distance: float = end_pos.position.distance_to(neighbour)
		if neighbour_distance < distance:
			best_neighbour = neighbour
			distance = neighbour_distance
	return best_neighbour
