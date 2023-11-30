extends CharacterBody2D


func _on_timer_timeout():
	$AnimatedSprite2D.set_animation("explode")
	
