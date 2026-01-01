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
	pass

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		debug_tilemap.clear()
		var neighbour_tracks: Array[Vector2i] = find_track_path()
		for track in neighbour_tracks:
			debug_tilemap.set_cell(track,2,Vector2i(1,0))
		#debug_tilemap.set_cell(neighbour_tracks.back(), 2, Vector2i(0,0))


func find_track_path()-> Array[Vector2i]:
	var current_tracks: Array[Vector2i] = track_tilemap.get_used_cells()
	var current_tile = track_tilemap.local_to_map(position)
	
	var stack: Array[Vector2i]
	var checked: Array[Vector2i]
	var path: Array[Vector2i]
	
	stack.append(current_tile)
	checked.append(current_tile)
	
	while stack.size() > 0:
		var tile = stack.pop_back()
		print("Tile: ", tile)
		
		var new_neighbours = find_track_neighbours(tile, current_tracks)
		var possible_paths: Array[Vector2i]
		var distance: float = 999
		var next_step: Vector2i
		for n in new_neighbours:
			if not checked.has(n):
				possible_paths.append(n)
				checked.append(n)
				print("Tile possible path added: ", n)
				for x in possible_paths:
					if end_pos.position.distance_to(track_tilemap.map_to_local(x)) < distance:
						next_step = x
						print("Next step is set to: ", x)
				print("adding next step: ", next_step)
				stack.append(next_step)
				path.append(next_step)
	print("returning path: ", path)
	return path

func find_track_neighbours(tile: Vector2i, tracks: Array[Vector2i]) -> Array[Vector2i]:
	var neighbour_tracks: Array[Vector2i] = []
	for dir in DIRECTIONS:
		var check_tile: Vector2i = tile + dir
		if tracks.has(check_tile):
			neighbour_tracks.append(check_tile)
	return neighbour_tracks
