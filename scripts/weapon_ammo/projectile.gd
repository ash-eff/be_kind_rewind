extends Sprite2D

@onready var game_manager = get_node("/root/GameManager")
@export var min_speed := 0
@export var max_speed := 50
@export var projectile_life_time := 1.0


var base_speed = 1000
var adjusted_speed = 0.0
var timer
var time_alive = 0
var is_rewinding = false
var vcr
var velocity = Vector2()
var direction = Vector2()
var slowdown_factor = .83

func _ready():
	adjusted_speed = base_speed + randf_range(min_speed, max_speed)
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", _on_timer_timeout)
	timer.one_shot = true
	timer.start(projectile_life_time)
	vcr = $VCR

func _physics_process(delta):
	if is_rewinding:
		return
	adjusted_speed *= slowdown_factor
	velocity = direction * adjusted_speed  * delta
	position += velocity
	if snapped(adjusted_speed, .01) <= 1:
		queue_free()
	

func _on_vcr_rewind_complete():
	is_rewinding = false
	timer.set_paused(false) 

func _on_vcr_rewind_start():
	is_rewinding = true
	timer.set_paused(true)

func _on_timer_timeout():
	pass
	#queue_free()
