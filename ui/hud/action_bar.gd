extends Control

@onready var track_button: Button = $PanelContainer/MarginContainer/Actions/PanelContainer/TrackButton
@onready var weapon_button: Button = $PanelContainer/MarginContainer/Actions/PanelContainer2/WeaponButton
@onready var nothing_button: Button = $PanelContainer/MarginContainer/Actions/PanelContainer3/NothingButton

# TODO be able to update weapon button icon

var player: Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	if player:
		match player.current_mode:
			Player.PLAYER_MODE.Track:
				track_button.grab_focus()
			Player.PLAYER_MODE.Weapon:
				weapon_button.grab_focus()
			Player.PLAYER_MODE.Nothing:
				nothing_button.grab_focus()
	else:
		print_debug("No Player Found.")


func _on_track_button_pressed() -> void:
	if player:
		track_button.grab_focus()
		player.current_mode = Player.PLAYER_MODE.Track

func _on_weapon_button_pressed() -> void:
	if player:
		weapon_button.grab_focus()
		player.current_mode = Player.PLAYER_MODE.Weapon

func _on_nothing_button_pressed() -> void:
	if player:
		player.current_mode = Player.PLAYER_MODE.Nothing
		nothing_button.grab_focus()
