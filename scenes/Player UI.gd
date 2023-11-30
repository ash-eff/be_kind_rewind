extends CanvasLayer

@export var first_color : Color
@export var second_color : Color
var lerp_time = 0.25
var current_lerp_time = 0
var damage_overlay

func _ready():
	damage_overlay = $"Damage Overlay"
	damage_overlay.modulate = second_color

func _process(delta):
	current_lerp_time += delta
	if current_lerp_time > lerp_time:
		current_lerp_time = lerp_time
	
	var perc = current_lerp_time / lerp_time
	damage_overlay.modulate = lerp(first_color, second_color, perc)


func _on_player_on_player_damaged():
	current_lerp_time = 0
