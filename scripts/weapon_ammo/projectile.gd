extends RigidBody2D

@onready var game_manager = get_node("/root/GameManager")
@export var min_speed := 0
@export var max_speed := 200
@export var projectile_life_time := 1.0
@export var slowdown_factor := 15
var base_speed = 2000
var adjusted_speed = 0.0
var timer
var time_alive = 0
var is_rewinding = false
var vcr
var direction_angle = 0.0
var impulse_applied = false
var modulate_color = Color(1, 1, 1, 1)  # Initial color with alpha set to 1
var target_alpha = 0  # The target alpha value
var lerp_speed = 40  # Adjust this value to control the speed of the lerp


func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", _on_timer_timeout)
	timer.one_shot = true
	timer.start(projectile_life_time)
	#vcr = $VCR
	set_speed()
	
	
func _process(delta):
	if not impulse_applied:
		apply_impulse(Vector2(adjusted_speed,0).rotated(deg_to_rad(direction_angle)))
		impulse_applied = true

func _physics_process(delta):
	if is_rewinding:
		return
	
	if not impulse_applied:
		return
		
	var slowdown = Vector2(linear_velocity.x * slowdown_factor, linear_velocity.y * slowdown_factor)
	apply_force(-slowdown)
	
	if linear_velocity.length_squared() < 100:
		kill(delta)
		
func kill(delta):
	modulate_color.a = lerpf(modulate_color.a, target_alpha, lerp_speed * delta)
	modulate = modulate_color
	if modulate_color.a == 0.0:
		queue_free()


func set_speed():
	adjusted_speed = base_speed + randf_range(min_speed, max_speed)

func set_direction_angle(value):
	direction_angle = value

func _on_vcr_rewind_complete():
	is_rewinding = false
	timer.set_paused(false) 

func _on_vcr_rewind_start():
	is_rewinding = true
	timer.set_paused(true)

func _on_timer_timeout():
	pass
	#queue_free()
