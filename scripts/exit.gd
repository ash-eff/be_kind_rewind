extends Area2D

signal player_entered

var game_manager

func _ready():
	game_manager = get_node('/root/GameManager')
	connect("player_entered", game_manager.on_player_reached_exit)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		emit_signal("player_entered")
