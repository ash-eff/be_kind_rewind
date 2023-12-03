extends HBoxContainer

var full_heart = preload('res://assets/player/ui_heart1.png')
var empty_heart = preload('res://assets/player/ui_heart2.png')

func update_health(value):
	for i in get_child_count():
		if value > i:
			get_child(i).texture = full_heart
		else:
			get_child(i).texture = empty_heart
