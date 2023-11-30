extends Node2D

# this is an AutoLoad

signal on_coin_grabbed

var world
var coins = []

func _ready():
	world = get_tree().get_root().get_node("World")
	coins = world.is_in_group("Coins")
	for coin in coins:
		connect("on_coin_grabbed", coin.on_coin_grabbed)
