extends Control

@onready var track_count: Label = $PanelContainer/MarginContainer/Tracks/PanelContainer/HBoxContainer/TrackCount

var player: Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	if player:
		player.connect("track_changed", update_label)
		track_count.text = str(player.tracks)

func update_label():
	if player:
		track_count.text = str(player.tracks)
