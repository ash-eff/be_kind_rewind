extends Node2D

var player_scene = preload('res://scenes/player.tscn')
var world
var level_entrance
var vcrs = []
var player
var rewind_speed = 2.0
var recording_duration = 3.0

func _ready():
	start_game()
	
func start_game():
	world = get_tree().get_root().get_node("World")
	if world:
		level_entrance = world.get_node("Entrance")
		player = player_scene.instantiate()
		world.add_child(player)
	
func on_player_reached_exit():
	get_tree().reload_current_scene()
	call_deferred('start_game')

func on_player_spotted():
	on_player_reached_exit()

