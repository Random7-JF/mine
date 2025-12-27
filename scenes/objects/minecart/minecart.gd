extends CharacterBody2D
class_name Minecart

@onready var sprite: Sprite2D = $Sprite2D
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var anim_tree: AnimationTree = $AnimationTree

@export var speed: int = 10
@export var sprite_up: Texture2D
@export var sprite_left: Texture2D
@export var sprite_diagonal: Texture2D

# TODO needs to find a path and move on that path
# TODO need to change sprite depending on direction moving. 
var track_tilemap: TileMapLayer
var start_pos: Marker2D
var end_pos: Marker2D

func _ready() -> void:
	track_tilemap = get_tree().get_first_node_in_group("minecart_tracks")
	start_pos = get_tree().get_first_node_in_group("minecart_start")
	end_pos = get_tree().get_first_node_in_group("minecart_end")
	
	var tile_coord = track_tilemap.local_to_map(start_pos.position)
	position = track_tilemap.map_to_local(tile_coord)
	
	nav.target_position = end_pos.global_position

func _process(_delta: float) -> void:
	if nav.is_target_reachable():
		var nav_point_direction = to_local(nav.get_next_path_position()).normalized()
		velocity = nav_point_direction * speed
		anim_tree.set("parameters/Facing/blend_position", nav_point_direction)
		move_and_slide()
	
