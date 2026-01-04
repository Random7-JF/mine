extends Control

@onready var track_button: Button = $PanelContainer/MarginContainer/Actions/PanelContainer/TrackButton
@onready var weapon_button: Button = $PanelContainer/MarginContainer/Actions/PanelContainer2/WeaponButton
@onready var nothing_button: Button = $PanelContainer/MarginContainer/Actions/PanelContainer3/NothingButton

# TODO be able to update weapon button icon

var player: Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")


func _on_track_button_pressed() -> void:
	if player:
		player.current_mode = Player.PLAYER_MODE.Track


func _on_weapon_button_pressed() -> void:
	if player:
		player.current_mode = Player.PLAYER_MODE.Weapon


func _on_nothing_button_pressed() -> void:
	if player:
		player.current_mode = Player.PLAYER_MODE.Nothing
