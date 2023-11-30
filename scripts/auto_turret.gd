extends StaticBody2D

var sprite : Sprite2D
var vision_cone 

var direction = 0

@export var rotate = true

func _ready():
	vision_cone = $vision_cone
	sprite = $Sprite2D
	

func _process(_delta):
	if rotate:
		vision_cone.direction_angle += 1
		var new_angle = vision_cone.direction_angle + (vision_cone.vision_angle / 4)
		match(int(new_angle)):
			360:
				sprite.frame = 0
			45:
				sprite.frame = 1
			90:
				sprite.frame = 2
			135:
				sprite.frame = 3
			180:
				sprite.frame = 4
			225:
				sprite.frame = 5
			270:
				sprite.frame = 6
			315:
				sprite.frame = 7
