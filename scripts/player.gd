extends CharacterBody2D

signal on_player_rewind
signal on_player_done_rewind
signal on_trigger_pressed
signal on_player_damaged

@export var speed := 150.0
@export var acceleration := 10.0

@onready var animation_player := $AnimationPlayer
@onready var player_sprite := $Sprite2D
@onready var collision_box := $CollisionShape2D
@onready var state_machine := $StateMachine
@onready var weapon_holder := $"Weapon Holder"
@onready var game_manager := get_node("/root/GameManager")

var weapon_sprite
var input_direction : Vector2

func _ready():
	global_position = game_manager.level_entrance.get_global_position()
	
func _process(_delta) -> void:
	if Input.is_action_just_pressed('rewind'):
		if state_machine.get_current_state_name() != 'Rewind':
			state_machine.transition_to("Rewind")
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		emit_signal("on_trigger_pressed")
	if Input.is_action_just_pressed('P'):
		emit_signal("on_player_damaged")

func get_input_direction():
	input_direction = Input.get_vector("left", "right", "up", "down")
	return input_direction

func set_animation(animation):
	animation_player.play(animation)
		
func get_direction_to_mouse():
	var mouse_pos = get_global_mouse_position()
	var player_position = global_position
	var dir = (mouse_pos - player_position).normalized()
	return dir
		
func flip_sprite(dir):
	if dir.x >= 0:
		player_sprite.flip_h = false
	else:
		player_sprite.flip_h = true
	
func hide_weapon(is_hidden):
	weapon_holder.visible = !is_hidden
	
func take_damage():
	$Camera2D.apply_shake()

func rewind_complete():
	state_machine.transition_to("Idle")
	emit_signal('on_player_done_rewind')
