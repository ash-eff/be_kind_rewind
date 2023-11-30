extends Area2D

@export var first_color : Color
@export var second_color : Color

@onready var game_manager = get_node("/root/GameManager")

var speed = randf_range(290, 300)
var slowdown_factor = 0.98
var time_alive = 0
var is_rewinding = false
var vcr
var velocity = Vector2()
var amplitude = 1.0;
var period = 30.0;
var sprite

func _ready():
	vcr = $VCR
	sprite = $Sprite2D
	set_bullet_velocity()

func _process(_delta):
	var theta = Time.get_ticks_msec() / period
	var distance = (sin(theta) + 1) / 2
	sprite.modulate = lerp(first_color, second_color, distance)
#	if is_rewinding:
#		time_alive -= delta * vcr.rewind_speed
#		if snapped(time_alive, 0.05) <= 0.1:
#			queue_free()
#		return
#	time_alive += delta
	
func _physics_process(delta):
	if is_rewinding:
		return
	speed *= slowdown_factor
	position += velocity * delta

func set_bullet_velocity():
	speed = randf_range(290, 300)
	var direction = transform.x
	var player_speed = game_manager.player.velocity.length()
	velocity = direction * speed + game_manager.player.velocity.normalized() * player_speed

func _on_vcr_rewind_complete():
	is_rewinding = false

func _on_vcr_rewind_start():
	is_rewinding = true

func _on_timer_timeout():
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("mobs"):
		body.do_damage()
		queue_free()
