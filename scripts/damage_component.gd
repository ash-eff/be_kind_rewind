extends Area2D
class_name DamageComponent

@export var owner_type : OWNER
@export var damage_value := 1.0
enum OWNER {PLAYER, ENEMY}

func _ready():
	match owner_type:
		0:
			set_collision_layer_value(5, true)
		1:
			set_collision_layer_value(6, true)
