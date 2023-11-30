extends Node2D

signal rewind_start
signal rewind_complete

@onready var game_manager = get_node("/root/GameManager")

@export var is_active = true
@export var can_be_destroyed = false
@export var record_animation = false

var parent
var animated_sprite
var rewind_speed := 0
var record_duration := 0
var is_rewinding := false
var start_time := 0.0
var time_stamp := 0.0
var rewind_values := {
	'position': [],
	'rotation': [],
}

func _ready():
	parent = get_parent()
	if not parent:
		return
	rewind_speed = game_manager.rewind_speed
	record_duration = game_manager.recording_duration
	if record_animation:
		animated_sprite = parent.get_node("AnimatedSprite2D")
		rewind_values['animation'] = []
		rewind_values['animation_is_playing'] = []
		rewind_values['animation_frame'] = []
	
func _process(_delta):
	if not is_active:
		return
	if Input.is_action_just_pressed('rewind') and !is_rewinding:
		is_rewinding = true
		emit_signal('rewind_start')
		
func _physics_process(delta):
	if not parent or not is_active:
		return
		
	check_time_alive(delta)
	if not is_rewinding:
		if record_duration * Engine.physics_ticks_per_second == rewind_values['position'].size():
			for key in rewind_values.keys():
				rewind_values[key].pop_front()
		record()
	else:
		rewind()


		
func record():
	rewind_values['position'].append(parent.global_position)
	rewind_values['rotation'].append(parent.rotation)
	if record_animation:
		rewind_values['animation'].append(animated_sprite.get_animation())
		rewind_values['animation_is_playing'].append(animated_sprite.is_playing())
		rewind_values['animation_frame'].append(animated_sprite.get_frame())
	
		
func rewind():
	for i in range(int(rewind_speed)):
		var pos = rewind_values["position"].pop_back()
		var rot = rewind_values["rotation"].pop_back()
		

		if record_animation:
			rewind_animation()

		if len(rewind_values["position"]) == 0:
			parent.global_position = pos
			parent.rotation = rot
			emit_signal("rewind_complete")
			is_rewinding = false
			return
		parent.global_position = pos
		parent.rotation = rot

			
func rewind_animation():
	if not record_animation:
		return
		
	var animation = rewind_values["animation"].pop_back()
	var animation_is_playing = rewind_values["animation_is_playing"].pop_back()
	var animation_frame = rewind_values["animation_frame"].pop_back()

	if animation == '' or not animation_is_playing:
		return
	
	# if it's the last frame in the array, play forward at normal speed
	if len(rewind_values["animation_frame"]) == 0:
		animated_sprite.set_frame(animation_frame)
		animated_sprite.play()
	else: # reverse animation manually
		animated_sprite.set_animation(animation)
		animated_sprite.set_frame(animation_frame)


func check_time_alive(delta):
	if not is_rewinding:
		time_stamp += delta
	else:
		time_stamp -= (delta * rewind_speed)
		if (time_stamp - (delta * rewind_speed)) <= 0 and can_be_destroyed:
			parent.queue_free()

func on_player_rewind():
	is_rewinding = true
