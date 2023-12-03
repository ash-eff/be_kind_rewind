extends CanvasLayer

@export var first_color : Color
@export var second_color : Color
var lerp_time = 0.25
var current_lerp_time = 0
var damage_overlay

func _ready():
	damage_overlay = $"Damage Overlay"
	damage_overlay.modulate = second_color
	current_lerp_time = lerp_time

func _process(delta):
	current_lerp_time += delta
	if current_lerp_time > lerp_time:
		current_lerp_time = lerp_time
	
	var perc = current_lerp_time / lerp_time
	damage_overlay.modulate = lerp(first_color, second_color, perc)

func _on_health_reduced(health_value):
	current_lerp_time = 0
	$player_heart_container.update_health(health_value)
