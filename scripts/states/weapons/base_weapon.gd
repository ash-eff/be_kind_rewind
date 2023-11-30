extends Node2D

@export var Bullet : PackedScene
@export var Shell : PackedScene
@export var fireRate := 1.0

@onready var cooldown := $Timer
@onready var world = get_tree().get_root().get_node("World")
@onready var sprite_rotator := $Sprite_Rotator
@onready var weapon_sprite := sprite_rotator.get_node("Sprite2D")

var number_of_bullets = 8
var spread_angle = 35 
var new_direction = Vector2.ZERO 
var state_machine 

func _ready():
	owner.connect('on_trigger_pressed', shoot)
	state_machine = $StateMachine
	cooldown.wait_time = fireRate

func shoot():
	pass
			
func reload():
	pass
	
func eject_shell():
	var dir = get_direction()
	var shell = Shell.instantiate()
	shell.set_direction(dir)
	world.add_child(shell)
	var offset = Vector2(randf_range(-1, 0), randf_range(-1, 0))
	shell.global_position = global_position + offset * 15

func flip_sprite(dir):
	if dir.x < 0:
		weapon_sprite.scale.y = -1
	else:
		weapon_sprite.scale.y = 1
		
func rotate_weapon(dir):
	sprite_rotator.rotation = atan2(dir.y, dir.x)
	
func get_direction():
	return (get_global_mouse_position() - owner.global_position).normalized()
