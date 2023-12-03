extends Node2D
class_name HealthComponent

signal on_health_reduced(health_value)
signal on_health_increased(health_value)

@export var max_health : int
var current_health : int

func _ready():
	current_health = max_health
	
func reduce_health(amount):
	current_health -= amount
	emit_signal("on_health_reduced", current_health)
	
func increase_health(amount):
	current_health += amount
	if current_health > max_health:
		current_health = max_health
	emit_signal("on_health_increased", current_health)
